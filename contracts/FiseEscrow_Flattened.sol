// SPDX-License-Identifier: MIT
pragma solidity =0.8.24 >=0.4.16 >=0.6.2 ^0.8.20;

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

// lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol

// OpenZeppelin Contracts (last updated v5.4.0) (utils/introspection/IERC165.sol)

/**
 * @dev Interface of the ERC-165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[ERC].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[ERC section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol

// OpenZeppelin Contracts (last updated v5.4.0) (token/ERC20/IERC20.sol)

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol

// OpenZeppelin Contracts (last updated v5.1.0) (utils/StorageSlot.sol)
// This file was procedurally generated from scripts/generate/templates/StorageSlot.js.

/**
 * @dev Library for reading and writing primitive types to specific storage slots.
 *
 * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
 * This library helps with reading and writing to such slots without the need for inline assembly.
 *
 * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
 *
 * Example usage to set ERC-1967 implementation slot:
 * ```solidity
 * contract ERC1967 {
 *     // Define the slot. Alternatively, use the SlotDerivation library to derive the slot.
 *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
 *
 *     function _getImplementation() internal view returns (address) {
 *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
 *     }
 *
 *     function _setImplementation(address newImplementation) internal {
 *         require(newImplementation.code.length > 0);
 *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
 *     }
 * }
 * ```
 *
 * TIP: Consider using this library along with {SlotDerivation}.
 */
library StorageSlot {
    struct AddressSlot {
        address value;
    }

    struct BooleanSlot {
        bool value;
    }

    struct Bytes32Slot {
        bytes32 value;
    }

    struct Uint256Slot {
        uint256 value;
    }

    struct Int256Slot {
        int256 value;
    }

    struct StringSlot {
        string value;
    }

    struct BytesSlot {
        bytes value;
    }

    /**
     * @dev Returns an `AddressSlot` with member `value` located at `slot`.
     */
    function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `BooleanSlot` with member `value` located at `slot`.
     */
    function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `Bytes32Slot` with member `value` located at `slot`.
     */
    function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `Uint256Slot` with member `value` located at `slot`.
     */
    function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `Int256Slot` with member `value` located at `slot`.
     */
    function getInt256Slot(bytes32 slot) internal pure returns (Int256Slot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns a `StringSlot` with member `value` located at `slot`.
     */
    function getStringSlot(bytes32 slot) internal pure returns (StringSlot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `StringSlot` representation of the string storage pointer `store`.
     */
    function getStringSlot(string storage store) internal pure returns (StringSlot storage r) {
        assembly ("memory-safe") {
            r.slot := store.slot
        }
    }

    /**
     * @dev Returns a `BytesSlot` with member `value` located at `slot`.
     */
    function getBytesSlot(bytes32 slot) internal pure returns (BytesSlot storage r) {
        assembly ("memory-safe") {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `BytesSlot` representation of the bytes storage pointer `store`.
     */
    function getBytesSlot(bytes storage store) internal pure returns (BytesSlot storage r) {
        assembly ("memory-safe") {
            r.slot := store.slot
        }
    }
}

// lib/openzeppelin-contracts/contracts/interfaces/IERC165.sol

// OpenZeppelin Contracts (last updated v5.4.0) (interfaces/IERC165.sol)

// lib/openzeppelin-contracts/contracts/interfaces/IERC20.sol

// OpenZeppelin Contracts (last updated v5.4.0) (interfaces/IERC20.sol)

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

// lib/openzeppelin-contracts/contracts/utils/Pausable.sol

// OpenZeppelin Contracts (last updated v5.3.0) (utils/Pausable.sol)

/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context {
    bool private _paused;

    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    /**
     * @dev The operation failed because the contract is paused.
     */
    error EnforcedPause();

    /**
     * @dev The operation failed because the contract is not paused.
     */
    error ExpectedPause();

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        _requirePaused();
        _;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Throws if the contract is paused.
     */
    function _requireNotPaused() internal view virtual {
        if (paused()) {
            revert EnforcedPause();
        }
    }

    /**
     * @dev Throws if the contract is not paused.
     */
    function _requirePaused() internal view virtual {
        if (!paused()) {
            revert ExpectedPause();
        }
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

// lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol

// OpenZeppelin Contracts (last updated v5.5.0) (utils/ReentrancyGuard.sol)

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If EIP-1153 (transient storage) is available on the chain you're deploying at,
 * consider using {ReentrancyGuardTransient} instead.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 *
 * IMPORTANT: Deprecated. This storage-based reentrancy guard will be removed and replaced
 * by the {ReentrancyGuardTransient} variant in v6.0.
 *
 * @custom:stateless
 */
abstract contract ReentrancyGuard {
    using StorageSlot for bytes32;

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.ReentrancyGuard")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant REENTRANCY_GUARD_STORAGE =
        0x9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f00;

    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;

    /**
     * @dev Unauthorized reentrant call.
     */
    error ReentrancyGuardReentrantCall();

    constructor() {
        _reentrancyGuardStorageSlot().getUint256Slot().value = NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    /**
     * @dev A `view` only version of {nonReentrant}. Use to block view functions
     * from being called, preventing reading from inconsistent contract state.
     *
     * CAUTION: This is a "view" modifier and does not change the reentrancy
     * status. Use it only on view functions. For payable or non-payable functions,
     * use the standard {nonReentrant} modifier instead.
     */
    modifier nonReentrantView() {
        _nonReentrantBeforeView();
        _;
    }

    function _nonReentrantBeforeView() private view {
        if (_reentrancyGuardEntered()) {
            revert ReentrancyGuardReentrantCall();
        }
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be NOT_ENTERED
        _nonReentrantBeforeView();

        // Any calls to nonReentrant after this point will fail
        _reentrancyGuardStorageSlot().getUint256Slot().value = ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _reentrancyGuardStorageSlot().getUint256Slot().value = NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _reentrancyGuardStorageSlot().getUint256Slot().value == ENTERED;
    }

    function _reentrancyGuardStorageSlot() internal pure virtual returns (bytes32) {
        return REENTRANCY_GUARD_STORAGE;
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

// lib/openzeppelin-contracts/contracts/interfaces/IERC1363.sol

// OpenZeppelin Contracts (last updated v5.4.0) (interfaces/IERC1363.sol)

/**
 * @title IERC1363
 * @dev Interface of the ERC-1363 standard as defined in the https://eips.ethereum.org/EIPS/eip-1363[ERC-1363].
 *
 * Defines an extension interface for ERC-20 tokens that supports executing code on a recipient contract
 * after `transfer` or `transferFrom`, or code on a spender contract after `approve`, in a single transaction.
 */
interface IERC1363 is IERC20, IERC165 {
    /*
     * Note: the ERC-165 identifier for this interface is 0xb0202a11.
     * 0xb0202a11 ===
     *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
     *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
     *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
     *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)')) ^
     *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
     *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
     */

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`
     * and then calls {IERC1363Receiver-onTransferReceived} on `to`.
     * @param to The address which you want to transfer to.
     * @param value The amount of tokens to be transferred.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function transferAndCall(address to, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`
     * and then calls {IERC1363Receiver-onTransferReceived} on `to`.
     * @param to The address which you want to transfer to.
     * @param value The amount of tokens to be transferred.
     * @param data Additional data with no specified format, sent in call to `to`.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the allowance mechanism
     * and then calls {IERC1363Receiver-onTransferReceived} on `to`.
     * @param from The address which you want to send tokens from.
     * @param to The address which you want to transfer to.
     * @param value The amount of tokens to be transferred.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function transferFromAndCall(address from, address to, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the allowance mechanism
     * and then calls {IERC1363Receiver-onTransferReceived} on `to`.
     * @param from The address which you want to send tokens from.
     * @param to The address which you want to transfer to.
     * @param value The amount of tokens to be transferred.
     * @param data Additional data with no specified format, sent in call to `to`.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function transferFromAndCall(address from, address to, uint256 value, bytes calldata data) external returns (bool);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens and then calls {IERC1363Spender-onApprovalReceived} on `spender`.
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function approveAndCall(address spender, uint256 value) external returns (bool);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens and then calls {IERC1363Spender-onApprovalReceived} on `spender`.
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     * @param data Additional data with no specified format, sent in call to `spender`.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
}

// lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol

// OpenZeppelin Contracts (last updated v5.5.0) (token/ERC20/utils/SafeERC20.sol)

/**
 * @title SafeERC20
 * @dev Wrappers around ERC-20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    /**
     * @dev An operation with an ERC-20 token failed.
     */
    error SafeERC20FailedOperation(address token);

    /**
     * @dev Indicates a failed `decreaseAllowance` request.
     */
    error SafeERC20FailedDecreaseAllowance(address spender, uint256 currentAllowance, uint256 requestedDecrease);

    /**
     * @dev Transfer `value` amount of `token` from the calling contract to `to`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        if (!_safeTransfer(token, to, value, true)) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
     * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
     */
    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        if (!_safeTransferFrom(token, from, to, value, true)) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Variant of {safeTransfer} that returns a bool instead of reverting if the operation is not successful.
     */
    function trySafeTransfer(IERC20 token, address to, uint256 value) internal returns (bool) {
        return _safeTransfer(token, to, value, false);
    }

    /**
     * @dev Variant of {safeTransferFrom} that returns a bool instead of reverting if the operation is not successful.
     */
    function trySafeTransferFrom(IERC20 token, address from, address to, uint256 value) internal returns (bool) {
        return _safeTransferFrom(token, from, to, value, false);
    }

    /**
     * @dev Increase the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     *
     * IMPORTANT: If the token implements ERC-7674 (ERC-20 with temporary allowance), and if the "client"
     * smart contract uses ERC-7674 to set temporary allowances, then the "client" smart contract should avoid using
     * this function. Performing a {safeIncreaseAllowance} or {safeDecreaseAllowance} operation on a token contract
     * that has a non-zero temporary allowance (for that particular owner-spender) will result in unexpected behavior.
     */
    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 oldAllowance = token.allowance(address(this), spender);
        forceApprove(token, spender, oldAllowance + value);
    }

    /**
     * @dev Decrease the calling contract's allowance toward `spender` by `requestedDecrease`. If `token` returns no
     * value, non-reverting calls are assumed to be successful.
     *
     * IMPORTANT: If the token implements ERC-7674 (ERC-20 with temporary allowance), and if the "client"
     * smart contract uses ERC-7674 to set temporary allowances, then the "client" smart contract should avoid using
     * this function. Performing a {safeIncreaseAllowance} or {safeDecreaseAllowance} operation on a token contract
     * that has a non-zero temporary allowance (for that particular owner-spender) will result in unexpected behavior.
     */
    function safeDecreaseAllowance(IERC20 token, address spender, uint256 requestedDecrease) internal {
        unchecked {
            uint256 currentAllowance = token.allowance(address(this), spender);
            if (currentAllowance < requestedDecrease) {
                revert SafeERC20FailedDecreaseAllowance(spender, currentAllowance, requestedDecrease);
            }
            forceApprove(token, spender, currentAllowance - requestedDecrease);
        }
    }

    /**
     * @dev Set the calling contract's allowance toward `spender` to `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful. Meant to be used with tokens that require the approval
     * to be set to zero before setting it to a non-zero value, such as USDT.
     *
     * NOTE: If the token implements ERC-7674, this function will not modify any temporary allowance. This function
     * only sets the "standard" allowance. Any temporary allowance will remain active, in addition to the value being
     * set here.
     */
    function forceApprove(IERC20 token, address spender, uint256 value) internal {
        if (!_safeApprove(token, spender, value, false)) {
            if (!_safeApprove(token, spender, 0, true)) revert SafeERC20FailedOperation(address(token));
            if (!_safeApprove(token, spender, value, true)) revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Performs an {ERC1363} transferAndCall, with a fallback to the simple {ERC20} transfer if the target has no
     * code. This can be used to implement an {ERC721}-like safe transfer that relies on {ERC1363} checks when
     * targeting contracts.
     *
     * Reverts if the returned value is other than `true`.
     */
    function transferAndCallRelaxed(IERC1363 token, address to, uint256 value, bytes memory data) internal {
        if (to.code.length == 0) {
            safeTransfer(token, to, value);
        } else if (!token.transferAndCall(to, value, data)) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Performs an {ERC1363} transferFromAndCall, with a fallback to the simple {ERC20} transferFrom if the target
     * has no code. This can be used to implement an {ERC721}-like safe transfer that relies on {ERC1363} checks when
     * targeting contracts.
     *
     * Reverts if the returned value is other than `true`.
     */
    function transferFromAndCallRelaxed(
        IERC1363 token,
        address from,
        address to,
        uint256 value,
        bytes memory data
    ) internal {
        if (to.code.length == 0) {
            safeTransferFrom(token, from, to, value);
        } else if (!token.transferFromAndCall(from, to, value, data)) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Performs an {ERC1363} approveAndCall, with a fallback to the simple {ERC20} approve if the target has no
     * code. This can be used to implement an {ERC721}-like safe transfer that rely on {ERC1363} checks when
     * targeting contracts.
     *
     * NOTE: When the recipient address (`to`) has no code (i.e. is an EOA), this function behaves as {forceApprove}.
     * Oppositely, when the recipient address (`to`) has code, this function only attempts to call {ERC1363-approveAndCall}
     * once without retrying, and relies on the returned value to be true.
     *
     * Reverts if the returned value is other than `true`.
     */
    function approveAndCallRelaxed(IERC1363 token, address to, uint256 value, bytes memory data) internal {
        if (to.code.length == 0) {
            forceApprove(token, to, value);
        } else if (!token.approveAndCall(to, value, data)) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Imitates a Solidity `token.transfer(to, value)` call, relaxing the requirement on the return value: the
     * return value is optional (but if data is returned, it must not be false).
     *
     * @param token The token targeted by the call.
     * @param to The recipient of the tokens
     * @param value The amount of token to transfer
     * @param bubble Behavior switch if the transfer call reverts: bubble the revert reason or return a false boolean.
     */
    function _safeTransfer(IERC20 token, address to, uint256 value, bool bubble) private returns (bool success) {
        bytes4 selector = IERC20.transfer.selector;

        assembly ("memory-safe") {
            let fmp := mload(0x40)
            mstore(0x00, selector)
            mstore(0x04, and(to, shr(96, not(0))))
            mstore(0x24, value)
            success := call(gas(), token, 0, 0x00, 0x44, 0x00, 0x20)
            // if call success and return is true, all is good.
            // otherwise (not success or return is not true), we need to perform further checks
            if iszero(and(success, eq(mload(0x00), 1))) {
                // if the call was a failure and bubble is enabled, bubble the error
                if and(iszero(success), bubble) {
                    returndatacopy(fmp, 0x00, returndatasize())
                    revert(fmp, returndatasize())
                }
                // if the return value is not true, then the call is only successful if:
                // - the token address has code
                // - the returndata is empty
                success := and(success, and(iszero(returndatasize()), gt(extcodesize(token), 0)))
            }
            mstore(0x40, fmp)
        }
    }

    /**
     * @dev Imitates a Solidity `token.transferFrom(from, to, value)` call, relaxing the requirement on the return
     * value: the return value is optional (but if data is returned, it must not be false).
     *
     * @param token The token targeted by the call.
     * @param from The sender of the tokens
     * @param to The recipient of the tokens
     * @param value The amount of token to transfer
     * @param bubble Behavior switch if the transfer call reverts: bubble the revert reason or return a false boolean.
     */
    function _safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value,
        bool bubble
    ) private returns (bool success) {
        bytes4 selector = IERC20.transferFrom.selector;

        assembly ("memory-safe") {
            let fmp := mload(0x40)
            mstore(0x00, selector)
            mstore(0x04, and(from, shr(96, not(0))))
            mstore(0x24, and(to, shr(96, not(0))))
            mstore(0x44, value)
            success := call(gas(), token, 0, 0x00, 0x64, 0x00, 0x20)
            // if call success and return is true, all is good.
            // otherwise (not success or return is not true), we need to perform further checks
            if iszero(and(success, eq(mload(0x00), 1))) {
                // if the call was a failure and bubble is enabled, bubble the error
                if and(iszero(success), bubble) {
                    returndatacopy(fmp, 0x00, returndatasize())
                    revert(fmp, returndatasize())
                }
                // if the return value is not true, then the call is only successful if:
                // - the token address has code
                // - the returndata is empty
                success := and(success, and(iszero(returndatasize()), gt(extcodesize(token), 0)))
            }
            mstore(0x40, fmp)
            mstore(0x60, 0)
        }
    }

    /**
     * @dev Imitates a Solidity `token.approve(spender, value)` call, relaxing the requirement on the return value:
     * the return value is optional (but if data is returned, it must not be false).
     *
     * @param token The token targeted by the call.
     * @param spender The spender of the tokens
     * @param value The amount of token to transfer
     * @param bubble Behavior switch if the transfer call reverts: bubble the revert reason or return a false boolean.
     */
    function _safeApprove(IERC20 token, address spender, uint256 value, bool bubble) private returns (bool success) {
        bytes4 selector = IERC20.approve.selector;

        assembly ("memory-safe") {
            let fmp := mload(0x40)
            mstore(0x00, selector)
            mstore(0x04, and(spender, shr(96, not(0))))
            mstore(0x24, value)
            success := call(gas(), token, 0, 0x00, 0x44, 0x00, 0x20)
            // if call success and return is true, all is good.
            // otherwise (not success or return is not true), we need to perform further checks
            if iszero(and(success, eq(mload(0x00), 1))) {
                // if the call was a failure and bubble is enabled, bubble the error
                if and(iszero(success), bubble) {
                    returndatacopy(fmp, 0x00, returndatasize())
                    revert(fmp, returndatasize())
                }
                // if the return value is not true, then the call is only successful if:
                // - the token address has code
                // - the returndata is empty
                success := and(success, and(iszero(returndatasize()), gt(extcodesize(token), 0)))
            }
            mstore(0x40, fmp)
        }
    }
}

// src/core/MatchEscrow.sol

/**
 * @title MatchEscrow
 * @dev Universal "Banker" contract for Falken Protocol.
 * Supports N-player matches using dynamic arrays and commit-reveal logic.
 * Payments handled exclusively in USDC.
 */
abstract contract MatchEscrow is ReentrancyGuard, Ownable, Pausable {
    using SafeERC20 for IERC20;
    
    enum MatchStatus { OPEN, ACTIVE, SETTLED, VOIDED }
    enum Phase { COMMIT, REVEAL }

    struct Match {
        address[] players;
        uint256   stake;           // Initial amount per player (USDC)
        uint256   totalPot;        // Total pot including additional bets
        bytes32   logicId;         // FISE Logic Identifier
        uint8     maxPlayers;      // Capacity of this match
        uint8     currentRound;
        uint8[]   wins;            // Score for each player index
        uint8     drawCounter;     // Consecutive draw counter for sudden death
        uint8     winsRequired;    // Rounds needed to win (1 for single-round, 3 for best-of-5, etc.)
        Phase     phase;
        MatchStatus status;
        uint256   commitDeadline;
        uint256   revealDeadline;
        address   winner;          // Final winner address
    }

    struct RoundCommit {
        bytes32  commitHash;
        uint8    move;
        bytes32  salt;
        bool     revealed;
    }

    uint256 public matchCounter;
    uint256 public constant RAKE_BPS = 500; // 5% total rake
    address public treasury;
    IERC20 public immutable usdc;

    mapping(uint256 => Match) public matches;
    // matchId => round => player => commit
    mapping(uint256 => mapping(uint8 => mapping(address => RoundCommit))) public roundCommits;
    // matchId => round => count of reveals
    mapping(uint256 => mapping(uint8 => uint8)) public roundRevealCount;
    // matchId => round => count of commits
    mapping(uint256 => mapping(uint8 => uint8)) public roundCommitCount;
    // matchId => player => contribution
    mapping(uint256 => mapping(address => uint256)) public playerContributions;

    mapping(address => uint256) public pendingWithdrawals;

    uint256 public constant COMMIT_WINDOW = 30 minutes;
    uint256 public constant REVEAL_WINDOW = 30 minutes;
    uint8 public constant MAX_ROUNDS = 10;

    event MatchCreated(uint256 indexed matchId, address indexed creator, uint256 stake, bytes32 indexed logicId, uint8 maxPlayers, uint8 winsRequired);
    event MatchJoined(uint256 indexed matchId, address indexed player, uint8 index);
    event MoveCommitted(uint256 indexed matchId, uint8 round, address indexed player);
    event MoveRevealed(uint256 indexed matchId, uint8 round, address indexed player, uint8 move, bytes32 salt);
    event RoundResolved(uint256 indexed matchId, uint8 round, uint8 winnerIndex);
    event MatchSettled(uint256 indexed matchId, address winner, uint256 payout);
    event MatchVoided(uint256 indexed matchId, string reason);
    event WithdrawalQueued(address indexed user, uint256 amount);
    event BetPlaced(uint256 indexed matchId, address indexed player, uint256 amount, uint256 newTotalPot);

    constructor(address initialTreasury, address usdcAddress) Ownable(msg.sender) {
        require(initialTreasury != address(0), "Invalid treasury");
        require(usdcAddress != address(0), "Invalid USDC");
        treasury = initialTreasury;
        usdc = IERC20(usdcAddress);
    }

    /**
     * @dev Internal helper to check if an address is in a match.
     */
    function _isPlayer(uint256 matchId, address account) internal view returns (bool) {
        address[] memory p = matches[matchId].players;
        for (uint256 i = 0; i < p.length; i++) {
            if (p[i] == account) return true;
        }
        return false;
    }

    /**
     * @dev Joins a match.
     */
    function joinMatch(uint256 matchId) external nonReentrant whenNotPaused {
        Match storage m = matches[matchId];
        require(m.status == MatchStatus.OPEN, "Match not open");
        require(m.players.length < m.maxPlayers, "Match full");
        require(!_isPlayer(matchId, msg.sender), "Already joined");

        usdc.safeTransferFrom(msg.sender, address(this), m.stake);
        m.players.push(msg.sender);
        m.totalPot += m.stake;
        playerContributions[matchId][msg.sender] = m.stake;

        emit MatchJoined(matchId, msg.sender, uint8(m.players.length - 1));

        if (m.players.length == m.maxPlayers) {
            m.status = MatchStatus.ACTIVE;
            m.commitDeadline = block.timestamp + COMMIT_WINDOW;
        }
    }

    /**
     * @dev Allows a player to place an additional bet (raise) during ACTIVE status.
     * @param matchId The match ID
     * @param additionalUSDC Additional amount to bet
     */
    function placeBet(uint256 matchId, uint256 additionalUSDC) external nonReentrant whenNotPaused {
        Match storage m = matches[matchId];
        require(m.status == MatchStatus.ACTIVE, "Match not active");
        require(_isPlayer(matchId, msg.sender), "Not participant");
        require(additionalUSDC > 0, "Bet must be > 0");

        usdc.safeTransferFrom(msg.sender, address(this), additionalUSDC);
        
        m.totalPot += additionalUSDC;
        playerContributions[matchId][msg.sender] += additionalUSDC;

        emit BetPlaced(matchId, msg.sender, additionalUSDC, m.totalPot);
    }

    /**
     * @dev Commits a move.
     */
    function commitMove(uint256 matchId, bytes32 commitHash) external nonReentrant whenNotPaused {
        Match storage m = matches[matchId];
        require(m.status == MatchStatus.ACTIVE, "Not active");
        require(m.phase == Phase.COMMIT, "Wrong phase");
        require(block.timestamp <= m.commitDeadline, "Commit timeout");
        require(_isPlayer(matchId, msg.sender), "Not participant");
        require(roundCommits[matchId][m.currentRound][msg.sender].commitHash == bytes32(0), "Already committed");

        roundCommits[matchId][m.currentRound][msg.sender].commitHash = commitHash;
        roundCommitCount[matchId][m.currentRound]++;

        emit MoveCommitted(matchId, m.currentRound, msg.sender);

        if (roundCommitCount[matchId][m.currentRound] == m.maxPlayers) {
            m.phase = Phase.REVEAL;
            m.revealDeadline = block.timestamp + REVEAL_WINDOW;
        }
    }

    /**
     * @dev Reveals a move.
     */
    function revealMove(uint256 matchId, uint8 move, bytes32 salt) external nonReentrant whenNotPaused {
        Match storage m = matches[matchId];
        require(m.status == MatchStatus.ACTIVE, "Not active");
        require(m.phase == Phase.REVEAL, "Wrong phase");
        require(block.timestamp <= m.revealDeadline, "Reveal timeout");
        require(_isPlayer(matchId, msg.sender), "Not participant");
        require(!roundCommits[matchId][m.currentRound][msg.sender].revealed, "Already revealed");

        bytes32 expectedHash = keccak256(abi.encodePacked("FALKEN_V1", address(this), matchId, uint256(m.currentRound), msg.sender, uint256(move), salt));
        require(expectedHash == roundCommits[matchId][m.currentRound][msg.sender].commitHash, "Invalid hash");
        
        roundCommits[matchId][m.currentRound][msg.sender].move = move;
        roundCommits[matchId][m.currentRound][msg.sender].salt = salt;
        roundCommits[matchId][m.currentRound][msg.sender].revealed = true;
        roundRevealCount[matchId][m.currentRound]++;

        emit MoveRevealed(matchId, m.currentRound, msg.sender, move, salt);

        if (roundRevealCount[matchId][m.currentRound] == m.maxPlayers) {
            _resolveRound(matchId);
        }
    }

    function _resolveRound(uint256 matchId) internal virtual;

    /**
     * @dev Allows a player to claim win if opponent times out.
     * Can be called during COMMIT phase (opponent didn't commit) or REVEAL phase (opponent didn't reveal).
     */
    function claimTimeout(uint256 matchId) external nonReentrant whenNotPaused {
        Match storage m = matches[matchId];
        require(m.status == MatchStatus.ACTIVE, "Not active");
        require(_isPlayer(matchId, msg.sender), "Not participant");
        
        bool isCommitTimeout = (m.phase == Phase.COMMIT && block.timestamp > m.commitDeadline);
        bool isRevealTimeout = (m.phase == Phase.REVEAL && block.timestamp > m.revealDeadline);
        require(isCommitTimeout || isRevealTimeout, "Not timed out");
        
        // Check if caller has committed (for commit phase) or revealed (for reveal phase)
        bool callerActed = false;
        bool opponentActed = false;
        
        for (uint256 i = 0; i < m.players.length; i++) {
            address player = m.players[i];
            if (player == msg.sender) {
                if (m.phase == Phase.COMMIT) {
                    callerActed = roundCommits[matchId][m.currentRound][player].commitHash != bytes32(0);
                } else {
                    callerActed = roundCommits[matchId][m.currentRound][player].revealed;
                }
            } else {
                if (m.phase == Phase.COMMIT) {
                    if (roundCommits[matchId][m.currentRound][player].commitHash != bytes32(0)) {
                        opponentActed = true;
                    }
                } else {
                    if (roundCommits[matchId][m.currentRound][player].revealed) {
                        opponentActed = true;
                    }
                }
            }
        }
        
        // Caller must have acted, opponent must have NOT acted
        require(callerActed, "You must act first");
        require(!opponentActed, "Opponent acted");
        
        // Settle with caller as winner (find their index)
        uint8 winnerIndex = 255;
        for (uint8 i = 0; i < m.players.length; i++) {
            if (m.players[i] == msg.sender) {
                winnerIndex = i;
                break;
            }
        }
        
        emit MatchVoided(matchId, "Timeout claimed");
        _settleMatch(matchId, winnerIndex);
    }

    /**
     * @dev Allows mutual timeout - both players get refund minus penalty.
     * Can be called after timeout if NEITHER player acted.
     */
    function mutualTimeout(uint256 matchId) external nonReentrant whenNotPaused {
        Match storage m = matches[matchId];
        require(m.status == MatchStatus.ACTIVE, "Not active");
        require(_isPlayer(matchId, msg.sender), "Not participant");
        
        bool isCommitTimeout = (m.phase == Phase.COMMIT && block.timestamp > m.commitDeadline);
        bool isRevealTimeout = (m.phase == Phase.REVEAL && block.timestamp > m.revealDeadline);
        require(isCommitTimeout || isRevealTimeout, "Not timed out");
        
        // Check that NO player has committed (for commit phase) or revealed (for reveal phase)
        for (uint256 i = 0; i < m.players.length; i++) {
            address player = m.players[i];
            if (m.phase == Phase.COMMIT) {
                require(roundCommits[matchId][m.currentRound][player].commitHash == bytes32(0), "Someone committed");
            } else {
                require(!roundCommits[matchId][m.currentRound][player].revealed, "Someone revealed");
            }
        }
        
        // Refund with 1% penalty each (99% back)
        m.status = MatchStatus.VOIDED;
        uint256 refund = (m.stake * 99) / 100;
        uint256 penalty = m.stake - refund;
        
        for (uint256 i = 0; i < m.players.length; i++) {
            _safeTransferUSDC(m.players[i], refund);
        }
        
        // Penalty goes to treasury
        _safeTransferUSDC(treasury, penalty * m.players.length);
        
        emit MatchVoided(matchId, "Mutual timeout");
    }

    /**
     * @dev Payout logic for N-players. 
     * @param matchId ID of match
     * @param winnerIndex The index in the players array who won. 
     * Use 255 for Draw (splits pot).
     */
    function _settleMatch(uint256 matchId, uint8 winnerIndex) internal {
        Match storage m = matches[matchId];
        m.status = MatchStatus.SETTLED;
        m.phase = Phase.REVEAL; // Mark as finished
        uint256 totalPot = m.totalPot;
        uint256 rake = (totalPot * RAKE_BPS) / 10000;
        uint256 payout = totalPot - rake;

        _safeTransferUSDC(treasury, rake);

        if (winnerIndex == 255) {
            // Draw: Split remaining pot among all players
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

    function _safeTransferUSDC(address to, uint256 amount) internal {
        if (amount == 0 || to == address(0)) return;
        try usdc.transfer(to, amount) returns (bool success) {
            if (!success) {
                pendingWithdrawals[to] += amount;
                emit WithdrawalQueued(to, amount);
            }
        } catch {
            pendingWithdrawals[to] += amount;
            emit WithdrawalQueued(to, amount);
        }
    }

    function withdraw() external nonReentrant {
        uint256 amount = pendingWithdrawals[msg.sender];
        require(amount > 0, "No balance");
        pendingWithdrawals[msg.sender] = 0;
        usdc.safeTransfer(msg.sender, amount);
    }

    function setTreasury(address newTreasury) external onlyOwner {
        require(newTreasury != address(0), "Invalid address");
        treasury = newTreasury;
    }

    /**
     * @dev Allows owner to set wins required for a match (for single-round or custom formats).
     */
    function setWinsRequired(uint256 matchId, uint8 winsRequired) external onlyOwner {
        Match storage m = matches[matchId];
        require(m.status == MatchStatus.OPEN || m.status == MatchStatus.ACTIVE, "Match not active");
        require(winsRequired > 0, "Wins required must be > 0");
        m.winsRequired = winsRequired;
    }

    /**
     * @dev Allows owner to void any match and refund stakes.
     */
    function adminVoidMatch(uint256 matchId) external onlyOwner {
        Match storage m = matches[matchId];
        require(m.status == MatchStatus.OPEN || m.status == MatchStatus.ACTIVE, "Cannot void");
        
        m.status = MatchStatus.VOIDED;
        m.phase = Phase.REVEAL; // Mark as finished
        for (uint256 i = 0; i < m.players.length; i++) {
            _safeTransferUSDC(m.players[i], m.stake);
        }
        emit MatchVoided(matchId, "Admin intervention");
    }

    function getMatch(uint256 matchId) external view returns (Match memory) {
        return matches[matchId];
    }

    /**
     * @dev Returns the commit hash and revealed status for a player in a round.
     */
    function getRoundStatus(uint256 matchId, uint8 round, address player) external view returns (bytes32 commitHash, bytes32 salt, bool revealed) {
        RoundCommit storage rc = roundCommits[matchId][round][player];
        return (rc.commitHash, rc.salt, rc.revealed);
    }

    receive() external payable {
        emit ETHReceived(msg.sender, msg.value);
    }

    event ETHReceived(address indexed sender, uint256 amount);

    function withdrawETH() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH to withdraw");
        payable(owner()).transfer(balance);
    }
}

// src/core/FiseEscrow.sol

/**
 * @title FiseEscrow
 * @dev Extension of MatchEscrow to support the Falken Immutable Scripting Engine (FISE).
 * Architected for N-player scalability.
 */
contract FiseEscrow is MatchEscrow {
    using SafeERC20 for IERC20;
    
    LogicRegistry public immutable logicRegistry;
    address public referee;

    // Default wins required for multi-round games (like Poker)
    uint8 public constant DEFAULT_WINS_REQUIRED = 3;
    uint8 public constant DRAW_INDEX = 255;
    uint8 public constant MAX_CONSECUTIVE_DRAWS = 3;
    uint16 public constant ROYALTY_BPS = 200; // 2% developer royalty

    event RefereeChanged(address indexed oldReferee, address indexed newReferee);
    event RoundStarted(uint256 indexed matchId, uint8 round);

    modifier onlyReferee() {
        require(msg.sender == referee, "Only Referee can call");
        _;
    }

    constructor(
        address initialTreasury, 
        address usdcAddress, 
        address initialLogicRegistry,
        address initialReferee
    ) MatchEscrow(initialTreasury, usdcAddress) {
        require(initialLogicRegistry != address(0), "Invalid registry");
        require(initialReferee != address(0), "Invalid referee");
        logicRegistry = LogicRegistry(initialLogicRegistry);
        referee = initialReferee;
    }

    /**
     * @dev Sets a new authorized referee address (Falken VM).
     */
    function setReferee(address newReferee) external onlyOwner {
        require(newReferee != address(0), "Invalid referee");
        emit RefereeChanged(referee, newReferee);
        referee = newReferee;
    }

    /**
     * @dev Creates a match using FISE logicId and configurable maxPlayers.
     * @param stake Entry stake in USDC.
     * @param logicId The registered ID from LogicRegistry.
     * @param maxPlayers Number of players needed to start.
     * @param winsRequired Rounds needed to win (1 for single-round, 3 for best-of-5, etc.)
     */
    function createMatch(uint256 stake, bytes32 logicId, uint8 maxPlayers, uint8 winsRequired) external nonReentrant whenNotPaused {
        require(winsRequired > 0, "Wins required must be > 0");
        require(stake > 0, "Stake must be > 0");
        require(maxPlayers >= 2, "Minimum 2 players");
        
        // 1. Verify Logic exists in Registry
        (string memory cid,,,,) = logicRegistry.registry(logicId);
        require(bytes(cid).length > 0, "Logic ID not registered");

        // 2. Pull USDC from creator
        usdc.safeTransferFrom(msg.sender, address(this), stake);

        uint256 matchId = ++matchCounter;
        
        // Initialize dynamic players array
        Match storage m = matches[matchId];
        m.players.push(msg.sender);
        m.stake = stake;
        m.logicId = logicId;
        m.maxPlayers = maxPlayers;
        m.currentRound = 1;
        m.phase = Phase.COMMIT;
        m.status = MatchStatus.OPEN;
        
        // Initialize wins array and set winsRequired (creator chooses)
        for (uint256 i = 0; i < maxPlayers; i++) {
            m.wins.push(0);
        }
        m.winsRequired = winsRequired;

        // Set initial total pot and contribution
        m.totalPot = stake;
        playerContributions[matchId][msg.sender] = stake;

        emit MatchCreated(matchId, msg.sender, stake, logicId, maxPlayers, winsRequired);
    }

    /**
     * @dev Implementation of round resolution for FISE.
     * Waits for Referee to call resolveFiseRound.
     */
    function _resolveRound(uint256 /*matchId*/) internal override {
        // Asynchronous resolution via Referee
        return;
    }

    /**
     * @dev Authorized Referee call to resolve a single FISE round.
     * @param roundWinnerIndex The index of the player who won the round (0 to maxPlayers-1).
     * Use 255 for a DRAW.
     */
    function resolveFiseRound(uint256 matchId, uint8 roundWinnerIndex) external nonReentrant onlyReferee {
        Match storage m = matches[matchId];
        require(m.status == MatchStatus.ACTIVE, "Match not active");
        require(m.phase == Phase.REVEAL, "Not in reveal phase");
        require(roundRevealCount[matchId][m.currentRound] == m.maxPlayers, "Not everyone revealed");

        if (roundWinnerIndex != DRAW_INDEX) {
            require(roundWinnerIndex < m.maxPlayers, "Invalid winner index");
            m.wins[roundWinnerIndex]++;
            m.drawCounter = 0;
        } else {
            m.drawCounter++;
        }

        emit RoundResolved(matchId, m.currentRound, roundWinnerIndex);

        // Cleanup round storage
        for (uint256 i = 0; i < m.players.length; i++) {
            delete roundCommits[matchId][m.currentRound][m.players[i]];
        }
        delete roundRevealCount[matchId][m.currentRound];
        delete roundCommitCount[matchId][m.currentRound];

        // Check for match completion
        // For N-player, we settle if someone hits 3 wins or if max rounds reached
        bool matchFinished = false;
        if (roundWinnerIndex != DRAW_INDEX && m.wins[roundWinnerIndex] >= m.winsRequired) {
            matchFinished = true;
        } else if (m.currentRound >= MAX_ROUNDS) {
            matchFinished = true;
        }

        if (matchFinished) {
            _settleFiseMatch(matchId);
            return;
        }

        // Handle progression
        if (roundWinnerIndex == DRAW_INDEX && m.drawCounter < MAX_CONSECUTIVE_DRAWS) {
            // Sudden death replay same round
        } else {
            m.currentRound++;
            m.drawCounter = 0;
        }

        m.phase = Phase.COMMIT;
        m.commitDeadline = block.timestamp + COMMIT_WINDOW;
        emit RoundStarted(matchId, m.currentRound);
    }

    /**
     * @dev Settles FISE match with developer royalties.
     */
    function _settleFiseMatch(uint256 matchId) internal {
        Match storage m = matches[matchId];
        
        // 1. Identify Match Winner
        uint8 winnerIndex = DRAW_INDEX; // Default to Draw
        uint8 maxWins = 0;
        for (uint8 i = 0; i < m.wins.length; i++) {
            if (m.wins[i] > maxWins) {
                maxWins = m.wins[i];
                winnerIndex = i;
            } else if (m.wins[i] == maxWins && maxWins > 0) {
                winnerIndex = DRAW_INDEX; // Tied
            }
        }

        // 2. Record volume in LogicRegistry
        logicRegistry.recordVolume(m.logicId, m.totalPot);

        // 3. Payout to winners (delegates to MatchEscrow for rake/transfer)
        _settleMatch(matchId, winnerIndex);
    }
}

