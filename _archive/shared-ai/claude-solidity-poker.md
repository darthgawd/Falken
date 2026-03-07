# 🛡️ Falken Protocol - Solidity Security & Accounting Audit

## 📋 Audit Context: V3 Hardening
We have recently refactored the `FiseEscrow.sol` and `MatchEscrow.sol` contracts to support Universal Multiplayer (N-players) and USDC-only betting. 

### Recent Refactor Details:
1.  **Bug Found:** `_settleFiseMatch` was recalculating `totalPot` from `m.stake * m.players.length`, ignoring additional bets and causing volume inflation.
2.  **Bug Found:** Double-raking was occurring because both `FiseEscrow.sol` and the parent `MatchEscrow.sol` were calculating and transferring the 5% rake.
3.  **Fix Applied:** Consolidated all rake and transfer logic into the internal `_settleMatch` function. `FiseEscrow.sol` now only identifies the winner and records volume before delegating settlement to the parent.

## 🎯 Objective
Achieve 100% logical parity with the original "Main Branch" contracts while maintaining the new N-player array architecture. Ensure no accounting leaks or security flaws exist in the payout flow.

---

## 🤖 Claude Audit Prompt

**Role:** Senior Solidity Security Researcher & Financial Auditor.

**Task:** Perform a deep-dive security and accounting audit of the following settlement logic from the Falken Protocol. 

**Context:**
- The protocol uses a 5% total rake (`RAKE_BPS = 500`).
- For FISE games, a 2% developer royalty (`ROYALTY_BPS = 200`) is paid out *from* that 5% rake.
- The system must handle N-players and accurately distribute remaining funds in case of a Draw (255).

**Audit Focus Areas:**
1.  **Rounding Errors:** Ensure that integer division in `payout / m.players.length` (for Draws) doesn't leave dust stuck in the contract.
2.  **Double-Spending/Raking:** Verify that rake and royalties are deducted exactly once and the math sums to `m.totalPot`.
3.  **CEI Pattern:** Ensure state changes (`MatchStatus.SETTLED`) occur before external transfers.
4.  **USDC Precision:** Confirm all math works correctly with 6-decimal USDC.
5.  **Logic Parity:** Does this implementation match the intent of a standard winner-take-all poker pool?

### 📦 Source Code for Audit:

#### 1. FiseEscrow.sol (Child)
```solidity
    function _settleFiseMatch(uint256 matchId) internal {
        Match storage m = matches[matchId];
        
        // Identify Match Winner
        uint8 winnerIndex = DRAW_INDEX;
        uint8 maxWins = 0;
        for (uint8 i = 0; i < m.wins.length; i++) {
            if (m.wins[i] > maxWins) {
                maxWins = m.wins[i];
                winnerIndex = i;
            } else if (m.wins[i] == maxWins && maxWins > 0) {
                winnerIndex = DRAW_INDEX; // Tied
            }
        }

        // Record volume and delegate settlement
        logicRegistry.recordVolume(m.logicId, m.totalPot);
        _settleMatch(matchId, winnerIndex);
    }
```

#### 2. MatchEscrow.sol (Parent)
```solidity
    function _settleMatch(uint256 matchId, uint8 winnerIndex) internal {
        Match storage m = matches[matchId];
        m.status = MatchStatus.SETTLED;
        m.phase = Phase.REVEAL; 
        uint256 totalPot = m.totalPot;
        uint256 rake = (totalPot * RAKE_BPS) / 10000;
        uint256 payout = totalPot - rake;

        _safeTransferUSDC(treasury, rake);

        if (winnerIndex == 255) {
            uint256 split = payout / m.players.length;
            for (uint256 i = 0; i < m.players.length; i++) {
                _safeTransferUSDC(m.players[i], split);
            }
            m.winner = address(0);
            emit MatchSettled(matchId, address(0), split);
        } else {
            address winnerAddr = m.players[winnerIndex];
            m.winner = winnerAddr;
            _safeTransferUSDC(winnerAddr, payout);
            emit MatchSettled(matchId, winnerAddr, payout);
        }
    }
```

**Instructions:** Please analyze these snippets and report any vulnerabilities or accounting discrepancies.
