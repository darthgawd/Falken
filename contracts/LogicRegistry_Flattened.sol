// SPDX-License-Identifier: MIT
pragma solidity =0.8.24 ^0.8.20;

// lib/openzeppelin-contracts/contracts/utils/Context.sol

// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// lib/openzeppelin-contracts/contracts/access/Ownable.sol

// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// src/core/LogicRegistry.sol

/**
 * @title LogicRegistry
 * @dev On-chain registry for Falken Immutable Scripting Engine (FISE) game logic.
 * Developers register their IPFS CID (Immutable Script Hash) here.
 */
contract LogicRegistry is Ownable {
    
    struct GameLogic {
        string ipfsCid;      // The IPFS hash of the JavaScript logic
        address developer;   // The wallet that deployed/owns the logic
        bool isVerified;     // Whether the protocol has audited/verified this logic
        uint256 createdAt;   // Registration timestamp
        uint256 totalVolume; // Aggregated ETH volume played via this logic
    }

    // Mapping from a logic ID (keccak256 of CID) to GameLogic metadata
    mapping(bytes32 => GameLogic) public registry;
    
    // Quick lookup for all registered logic IDs
    bytes32[] public allLogicIds;

    event LogicRegistered(bytes32 indexed logicId, string ipfsCid, address indexed developer);
    event LogicVerified(bytes32 indexed logicId, bool status);

    constructor() Ownable(msg.sender) {}

    /**
     * @dev Registers a new game logic via its IPFS CID.
     * Restricted to Protocol Owner for curated Beta phase.
     */
    function registerLogic(string calldata ipfsCid, address developer) external onlyOwner returns (bytes32) {
        bytes32 logicId = keccak256(abi.encodePacked(ipfsCid));
        
        require(bytes(registry[logicId].ipfsCid).length == 0, "Logic already registered");

        registry[logicId] = GameLogic({
            ipfsCid: ipfsCid,
            developer: developer,
            isVerified: false,
            createdAt: block.timestamp,
            totalVolume: 0
        });

        allLogicIds.push(logicId);

        emit LogicRegistered(logicId, ipfsCid, developer);
        return logicId;
    }

    /**
     * @dev Allows protocol owner to verify logic for high-stakes play.
     */
    function setVerificationStatus(bytes32 logicId, bool status) external onlyOwner {
        require(bytes(registry[logicId].ipfsCid).length > 0, "Logic not found");
        registry[logicId].isVerified = status;
        emit LogicVerified(logicId, status);
    }

    /**
     * @dev Records volume for a specific logic (called by MatchEscrow).
     */
    function recordVolume(bytes32 logicId, uint256 amount) external {
        // In future, restrict to authorized Escrow addresses
        registry[logicId].totalVolume += amount;
    }

    /**
     * @dev Returns the total number of registered games.
     */
    function getRegistryCount() external view returns (uint256) {
        return allLogicIds.length;
    }
}

