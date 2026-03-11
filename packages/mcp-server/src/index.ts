// --- STDOUT PROTECTION ---
// Redirect all console.log and process.stdout to stderr to prevent breaking JSON-RPC on stdio
console.log = console.error;
const originalWrite = process.stdout.write.bind(process.stdout);
process.stdout.write = ((chunk: any, encoding: any, callback: any) => {
  if (typeof chunk === 'string' && (chunk.startsWith('{') || chunk.startsWith('Content-Length'))) {
    return originalWrite(chunk, encoding, callback);
  }
  return process.stderr.write(chunk, encoding, callback);
}) as any;
// -------------------------

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { SSEServerTransport } from '@modelcontextprotocol/sdk/server/sse.js';
import express from 'express';
import cors from 'cors';

import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import { createClient } from '@supabase/supabase-js';
import { createPublicClient, http, encodeFunctionData, keccak256, encodePacked, createWalletClient, verifyMessage } from 'viem';
import { privateKeyToAccount } from 'viem/accounts';
import { baseSepolia } from 'viem/chains';
import dotenv from 'dotenv';
import * as crypto from 'node:crypto';
import path from 'path';
import { fileURLToPath } from 'url';
import pino from 'pino';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: path.resolve(__dirname, '../../../.env'), quiet: true } as any);
dotenv.config({ path: path.resolve(process.cwd(), '.env'), quiet: true } as any);

const logger = pino({}, process.stderr);

const supabase = createClient(
  process.env.SUPABASE_URL || '',
  process.env.SUPABASE_ANON_KEY || ''
);

const publicClient = createPublicClient({
  chain: baseSepolia,
  transport: http(process.env.RPC_URL),
});

const agentAccount = process.env.AGENT_PRIVATE_KEY 
  ? privateKeyToAccount(process.env.AGENT_PRIVATE_KEY as `0x${string}`)
  : null;

const walletClient = agentAccount 
  ? createWalletClient({
      account: agentAccount,
      chain: baseSepolia,
      transport: http(process.env.RPC_URL),
    })
  : null;

const ESCROW_ADDRESS = (process.env.ESCROW_ADDRESS || '0x0000000000000000000000000000000000000000').toLowerCase() as `0x${string}`;
const LOGIC_REGISTRY_ADDRESS = (process.env.LOGIC_REGISTRY_ADDRESS || '0x0000000000000000000000000000000000000000').toLowerCase() as `0x${string}`;
const MASTER_ENCRYPTION_KEY = process.env.MASTER_ENCRYPTION_KEY || 'default_key_32_chars_for_dev_only_!!';

/**
 * Encrypts a private key using AES-256-GCM.
 */
function encryptKey(privateKey: string): string {
  const iv = crypto.randomBytes(12);
  const cipher = crypto.createCipheriv('aes-256-gcm', Buffer.from(MASTER_ENCRYPTION_KEY.slice(0, 32)), iv);
  let encrypted = cipher.update(privateKey, 'utf8', 'hex');
  encrypted += cipher.final('hex');
  const authTag = cipher.getAuthTag().toString('hex');
  return `${iv.toString('hex')}:${authTag}:${encrypted}`;
}

const ESCROW_ABI = [
  { name: 'createMatch', type: 'function', stateMutability: 'nonpayable', inputs: [{ name: 'stake', type: 'uint256' }, { name: 'logicId', type: 'bytes32' }, { name: 'maxPlayers', type: 'uint8' }, { name: 'winsRequired', type: 'uint8' }], outputs: [] },
  { name: 'joinMatch', type: 'function', stateMutability: 'nonpayable', inputs: [{ name: 'matchId', type: 'uint256' }], outputs: [] },
  { name: 'commitMove', type: 'function', stateMutability: 'nonpayable', inputs: [{ name: '_matchId', type: 'uint256' }, { name: '_commitHash', type: 'bytes32' }], outputs: [] },
  { name: 'revealMove', type: 'function', stateMutability: 'nonpayable', inputs: [{ name: '_matchId', type: 'uint256' }, { name: '_move', type: 'uint8' }, { name: '_salt', type: 'bytes32' }], outputs: [] },
  { name: 'claimTimeout', type: 'function', stateMutability: 'nonpayable', inputs: [{ name: '_matchId', type: 'uint256' }], outputs: [] },
  { name: 'mutualTimeout', type: 'function', stateMutability: 'nonpayable', inputs: [{ name: '_matchId', type: 'uint256' }], outputs: [] },
  { name: 'withdraw', type: 'function', stateMutability: 'nonpayable', inputs: [], outputs: [] },
  { name: 'getMatch', type: 'function', stateMutability: 'view', inputs: [{ name: 'matchId', type: 'uint256' }], outputs: [{ name: '', type: 'tuple', components: [{ name: 'players', type: 'address[]' }, { name: 'stake', type: 'uint256' }, { name: 'totalPot', type: 'uint256' }, { name: 'logicId', type: 'bytes32' }, { name: 'maxPlayers', type: 'uint8' }, { name: 'currentRound', type: 'uint8' }, { name: 'wins', type: 'uint8[]' }, { name: 'drawCounter', type: 'uint8' }, { name: 'winsRequired', type: 'uint8' }, { name: 'phase', type: 'uint8' }, { name: 'status', type: 'uint8' }, { name: 'commitDeadline', type: 'uint256' }, { name: 'revealDeadline', type: 'uint256' }, { name: 'winner', type: 'address' }] }] },
  { name: 'getRoundStatus', type: 'function', stateMutability: 'view', inputs: [{ name: 'matchId', type: 'uint256' }, { name: 'round', type: 'uint8' }, { name: 'player', type: 'address' }], outputs: [{ name: 'commitHash', type: 'bytes32' }, { name: 'salt', type: 'bytes32' }, { name: 'revealed', type: 'bool' }] },
] as const;

const LOGIC_REGISTRY_ABI = [
  { name: 'getRegistryCount', type: 'function', stateMutability: 'view', inputs: [], outputs: [{ type: 'uint256' }] },
  { name: 'allLogicIds', type: 'function', stateMutability: 'view', inputs: [{ name: '', type: 'uint256' }], outputs: [{ type: 'bytes32' }] },
  { name: 'registry', type: 'function', stateMutability: 'view', inputs: [{ name: '', type: 'bytes32' }], outputs: [{ name: 'ipfsCid', type: 'string' }, { name: 'developer', type: 'address' }, { name: 'isVerified', type: 'bool' }, { name: 'createdAt', type: 'uint256' }, { name: 'totalVolume', type: 'uint256' }] },
] as const;

export const TOOLS = [
  {
    name: 'get_arena_overview',
    description: 'Returns a global snapshot of the arena including active stats, registered games, and the top 10 leaderboard.',
    inputSchema: { type: 'object' }
  },
  {
    name: 'manage_identity',
    description: 'Handles agent profiles, nicknames, and the secure salt vault. Use action WHO_AM_I to see your address.',
    inputSchema: {
      type: 'object',
      properties: {
        action: { type: 'string', enum: ['WHO_AM_I', 'SET_NICKNAME', 'GET_PROFILE', 'VAULT_STORE', 'VAULT_GET', 'SPAWN_AGENT'] },
        payload: { type: 'object' }
      },
      required: ['action']
    }
  },
  {
    name: 'sync_arena_state',
    description: 'Tracks real-time arena data. Use action FIND_MATCHES to see open games or SYNC_MATCH for turn info.',
    inputSchema: {
      type: 'object',
      properties: {
        action: { type: 'string', enum: ['FIND_MATCHES', 'SYNC_MATCH', 'GET_DIRECTIVES', 'GET_INTEL', 'CHECK_WALLET'] },
        payload: { type: 'object' }
      },
      required: ['action']
    }
  },
  {
    name: 'prepare_match_action',
    description: 'MANDATORY: Generates transaction data for all moves. After calling this, you MUST call execute_action.',
    inputSchema: {
      type: 'object',
      properties: {
        action: { type: 'string', enum: ['CREATE', 'JOIN', 'COMMIT', 'REVEAL', 'SETTLE', 'WITHDRAW'] },
        payload: { type: 'object' }
      },
      required: ['action']
    }
  },
  {
    name: 'execute_action',
    description: 'Signs and broadcasts a transaction. Use data from prepare_match_action.',
    inputSchema: {
      type: 'object',
      properties: {
        to: { type: 'string' },
        data: { type: 'string' },
        value: { type: 'string' },
        gasLimit: { type: 'string' }
      },
      required: ['to', 'data']
    }
  },
  { name: 'ping', description: 'Simple connection test.', inputSchema: { type: 'object' } },
];

// Helper Functions
async function prepTxWithBuffer(functionName: string, args: any[], value: bigint = 0n, account?: `0x${string}`) {
  const gas = await publicClient.estimateContractGas({ address: ESCROW_ADDRESS, abi: ESCROW_ABI, functionName, args, value, account } as any);
  const data = encodeFunctionData({ abi: ESCROW_ABI, functionName, args } as any);
  return { to: ESCROW_ADDRESS, data, value: value.toString(), gasLimit: ((gas * 120n) / 100n).toString() };
}

function parseMatchId(id: string): { dbId: string, onChainId: bigint } {
  if (id.includes('-')) return { dbId: id, onChainId: BigInt(id.split('-').pop()!) };
  return { dbId: `${ESCROW_ADDRESS}-${id}`, onChainId: BigInt(id) };
}

function calculatePokerHand(matchId: string, round: number, playerAddress: string, players: string[]) {
  const numericalId = matchId.split('-').pop() || matchId;
  const seedStr = `${numericalId}_${round}`;
  let hash = 0;
  for (let i = 0; i < seedStr.length; i++) {
    hash = ((hash << 5) - hash) + seedStr.charCodeAt(i);
    hash |= 0;
  }
  const deck = Array.from({ length: 52 }, (_, i) => i);
  for (let i = deck.length - 1; i > 0; i--) {
    hash = (Math.imul(1664525, hash) + 1013904223) | 0;
    const j = Math.abs(hash % (i + 1));
    [deck[i], deck[j]] = [deck[j], deck[i]];
  }
  const playerIdx = players.findIndex(p => p.toLowerCase() === playerAddress.toLowerCase());
  if (playerIdx === -1) return null;
  const handOffset = playerIdx * 5;
  const rawHand = deck.slice(handOffset, handOffset + 5);
  const ranks = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'];
  const suits = ['♣', '♦', '♥', '♠'];
  return rawHand.map(c => `${ranks[c % 13]}${suits[Math.floor(c / 13)]}`).join(' ');
}

async function getNicknames(addresses: string[]) {
  const { data } = await supabase.from('agent_profiles').select('address, nickname').in('address', addresses.map(a => a.toLowerCase()));
  const map: Record<string, string> = {};
  data?.forEach(p => map[p.address.toLowerCase()] = p.nickname);
  return map;
}

export async function handleToolCall(name: string, args: any) {
  logger.info({ tool: name, args }, 'Handling MCP tool call');

  if (name === 'get_arena_overview') {
    const { data: matches } = await supabase.from('matches').select('stake_wei').eq('status', 'ACTIVE');
    const { data: lead } = await supabase.from('agent_profiles').select('nickname, address, elo').order('elo', { ascending: false }).limit(5);
    const count = await publicClient.readContract({ address: LOGIC_REGISTRY_ADDRESS, abi: LOGIC_REGISTRY_ABI, functionName: 'getRegistryCount' });
    
    const activeTvlRaw = (matches || []).reduce((acc, m) => acc + BigInt(m.stake_wei), 0n);
    const activeTvlFormatted = `$${(Number(activeTvlRaw) / 1e6).toFixed(2)}`;

    return {
      active_matches: (matches || []).length,
      active_tvl: activeTvlFormatted,
      logic_count: Number(count),
      leaderboard: lead,
      message: "Arena operational."
    };
  }

  if (name === 'manage_identity') {
    const { action, payload } = args;
    if (action === 'WHO_AM_I') {
      if (!agentAccount) throw new Error('AGENT_PRIVATE_KEY not configured');
      return { address: agentAccount.address };
    }
    if (action === 'VAULT_GET') {
      const { matchId, round, playerAddress } = payload;
      const { dbId } = parseMatchId(matchId);
      const { data } = await supabase.from('hosted_agent_salts').select('*').match({ agent_address: playerAddress.toLowerCase(), match_id: dbId, round_number: round }).single();
      if (!data) throw new Error('Secret not found');
      return { move: data.move_value, salt: data.salt_value };
    }
  }

  if (name === 'sync_arena_state') {
    const { action, payload } = args;
    if (action === 'FIND_MATCHES') {
      const { data: matches } = await supabase.from('matches').select('*').eq('status', 'OPEN').eq('is_fise', true).limit(5);
      const addresses = matches?.flatMap(m => m.players) || [];
      const names = await getNicknames(addresses);
      return matches?.map(m => ({ 
        ...m, 
        stake_formatted: `$${(Number(m.stake_wei) / 1e6).toFixed(2)}`,
        player_nicknames: m.players.map((p: string) => names[p.toLowerCase()] || p.slice(0,6)) 
      })) || [];
    }
    if (action === 'SYNC_MATCH') {
      const { matchId, playerAddress } = payload;
      const { dbId } = parseMatchId(matchId);
      const { data: match } = await supabase.from('matches').select('*').eq('match_id', dbId).single();
      const { data: rounds } = await supabase.from('rounds').select('*').match({ match_id: dbId, round_number: match.current_round });
      
      let hand = null;
      if (match.game_logic.toLowerCase() === "0x941e596b0c66e32eb8186fe5c43b990e128b0469bb9fe233512c2ad8a7b254c5") {
        hand = calculatePokerHand(dbId, match.current_round, playerAddress, match.players);
      }
      
      return { 
        match: {
          ...match,
          stake_formatted: `$${(Number(match.stake_wei) / 1e6).toFixed(2)}`,
          total_pot_formatted: `$${(Number(match.total_pot) / 1e6).toFixed(2)}`
        }, 
        rounds, 
        hand 
      };
    }
  }

  if (name === 'prepare_match_action') {
    const { action, payload } = args;
    if (action === 'CREATE') {
      const { stakeUSDC, gameLogic, players, wins, playerAddress } = payload;
      const stakeWei = BigInt(Math.floor(stakeUSDC * 1e6));
      return await prepTxWithBuffer('createMatch', [stakeWei, gameLogic, players || 2, wins || 3], 0n, playerAddress);
    }
    if (action === 'JOIN') {
      const { onChainId } = parseMatchId(payload.matchId);
      const { data } = await supabase.from('matches').select('stake_wei').eq('match_id', parseMatchId(payload.matchId).dbId).single();
      if (!data) throw new Error('Match data not found for join');
      return await prepTxWithBuffer('joinMatch', [onChainId], BigInt(data.stake_wei), payload.playerAddress);
    }
    if (action === 'COMMIT') {
      const { matchId, playerAddress, move } = payload;
      const { dbId, onChainId } = parseMatchId(matchId);
      const { data: match } = await supabase.from('matches').select('current_round').eq('match_id', dbId).single();
      if (!match) throw new Error('Match not found');
      
      const salt = `0x${crypto.randomBytes(32).toString('hex')}` as `0x${string}`;
      await supabase.from('hosted_agent_salts').upsert({ agent_address: playerAddress.toLowerCase(), match_id: dbId, round_number: match.current_round, move_value: move, salt_value: salt }, { onConflict: 'agent_address,match_id,round_number' });
      const hash = keccak256(encodePacked(['string', 'address', 'uint256', 'uint256', 'address', 'uint256', 'bytes32'], ["FALKEN_V1", ESCROW_ADDRESS, onChainId, BigInt(match.current_round), playerAddress, BigInt(move), salt]));
      const tx = await prepTxWithBuffer('commitMove', [onChainId, hash], 0n, playerAddress);
      return { ...tx, salt, move, matchId: dbId, vault_status: 'SAVED' };
    }
    if (action === 'REVEAL') {
      const { matchId, playerAddress } = payload;
      const { dbId, onChainId } = parseMatchId(matchId);
      const { data: match } = await supabase.from('matches').select('current_round').eq('match_id', dbId).single();
      if (!match) throw new Error('Match not found');
      
      const { data: secret } = await supabase.from('hosted_agent_salts').select('*').match({ agent_address: playerAddress.toLowerCase(), match_id: dbId, round_number: match.current_round }).single();
      if (!secret) throw new Error('No secret found in vault');
      return await prepTxWithBuffer('revealMove', [onChainId, secret.move_value, secret.salt_value], 0n, playerAddress);
    }
    if (action === 'WITHDRAW') {
      return await prepTxWithBuffer('withdraw', [], 0n, payload.playerAddress);
    }
    if (action === 'SETTLE') {
      // SETTLE is handled by Referee, but we can provide a manual trigger if needed
      throw new Error('Settle is automated via Referee Service');
    }
  }

  if (name === 'execute_action') {
    if (!walletClient || !agentAccount) throw new Error('Signer not ready');
    const hash = await walletClient.sendTransaction({ to: args.to, data: args.data, value: args.value ? BigInt(args.value) : 0n, gas: args.gasLimit ? BigInt(args.gasLimit) : undefined });
    return { hash, explorerUrl: `https://sepolia.basescan.org/tx/${hash}` };
  }

  if (name === 'ping') return { status: 'pong' };
  throw new Error(`Tool not found: ${name}`);
}

export const server = new Server({ name: 'falken-protocol', version: '0.2.0' }, { capabilities: { tools: {} } });

server.setRequestHandler(ListToolsRequestSchema, async () => ({ tools: TOOLS }));
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  try {
    const result = await handleToolCall(request.params.name, request.params.arguments);
    return { content: [{ type: 'text', text: JSON.stringify(result) }] };
  } catch (error: any) {
    return { content: [{ type: 'text', text: `Error: ${error.message}` }], isError: true };
  }
});

async function main() {
  const transportType = process.env.MCP_TRANSPORT || 'stdio';
  if (transportType === 'sse') {
    const app = express();
    app.use(cors());
    const port = process.env.PORT || 3001;
    const transports = new Map<string, SSEServerTransport>();
    let activeTransport: SSEServerTransport | null = null;

    app.get('/sse', async (req, res) => {
      try {
        logger.info('Received SSE connection request');
        const transport = new SSEServerTransport('/messages', res);
        const sessionId = transport.sessionId;
        transports.set(sessionId, transport);
        activeTransport = transport;
        
        try {
          await server.connect(transport);
          logger.info({ sessionId }, 'FALKEN MCP Hub connected via SSE');
        } catch (connErr: any) {
          logger.warn({ sessionId }, 'Server re-connecting to new transport');
        }

        const keepAliveInterval = setInterval(() => {
          if (!res.writableEnded) res.write(':ping\n\n');
        }, 30000);

        res.on('close', () => {
          clearInterval(keepAliveInterval);
          transports.delete(sessionId);
          if (activeTransport === transport) activeTransport = null;
        });
      } catch (err: any) {
        logger.error({ err: err.message }, 'Failed SSE connection');
        res.status(500).send(err.message);
      }
    });

    app.post('/messages', express.raw({ type: 'application/json', limit: '4mb' }), async (req, res) => {
      const sessionId = req.query.sessionId as string;
      const transport = transports.get(sessionId);
      if (!transport) {
        res.status(400).send('No active SSE connection');
        return;
      }
      try {
        const parsedBody = req.body ? JSON.parse(req.body.toString()) : undefined;
        await transport.handlePostMessage(req, res, parsedBody);
      } catch (err: any) {
        logger.error({ err: err.message }, 'POST message error');
        if (!res.headersSent) res.status(500).json({ error: err.message });
      }
    });

    app.listen(port, () => logger.info(`FALKEN Hub Server active on ${port}`));
  } else {
    await server.connect(new StdioServerTransport());
  }
}
main().catch(console.error);
