// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title A2APayment
 * @notice Agent-to-Agent 支付合约
 * @dev 实现 RL 环境订阅 + 按调用次数自动扣费（Web4.0 A2A 支付）
 */
contract A2APayment {
    struct Subscription {
        address subscriber;       // 订阅者（Agent）
        uint256 environmentId;    // RL 环境 ID
        uint256 callsRemaining;   // 剩余调用次数
        uint256 expiryTime;       // 过期时间
        uint256 pricePerCall;     // 每次调用价格（wei）
        bool active;              // 是否活跃
    }

    struct RLEnvironment {
        string name;
        address owner;
        uint256 pricePerCall;
        uint256 totalCalls;
        uint256 activeSubscriptions;
    }

    mapping(uint256 => Subscription) public subscriptions;
    mapping(uint256 => RLEnvironment) public environments;
    uint256 private _subscriptionCounter;
    uint256 private _environmentCounter;

    // 事件
    event EnvironmentCreated(
        uint256 indexed environmentId,
        string name,
        address indexed owner,
        uint256 pricePerCall
    );

    event SubscriptionPurchased(
        uint256 indexed subscriptionId,
        address indexed subscriber,
        uint256 indexed environmentId,
        uint256 calls,
        uint256 totalCost
    );

    event CallExecuted(
        uint256 indexed subscriptionId,
        uint256 timestamp,
        uint256 cost
    );

    event CallCharged(
        uint256 indexed subscriptionId,
        address indexed subscriber,
        address indexed environmentOwner,
        uint256 amount
    );

    /**
     * @notice 创建 RL 环境
     * @param name 环境名称
     * @param pricePerCall 每次调用价格（wei）
     */
    function createEnvironment(string memory name, uint256 pricePerCall) public returns (uint256) {
        require(pricePerCall > 0, "Price must be > 0");
        
        uint256 envId = _environmentCounter++;
        environments[envId] = RLEnvironment({
            name: name,
            owner: msg.sender,
            pricePerCall: pricePerCall,
            totalCalls: 0,
            activeSubscriptions: 0
        });
        
        emit EnvironmentCreated(envId, name, msg.sender, pricePerCall);
        return envId;
    }

    /**
     * @notice 购买订阅
     * @param environmentId 环境 ID
     * @param calls 调用次数
     * @param durationDays 有效期（天）
     */
    function buySubscription(
        uint256 environmentId,
        uint256 calls,
        uint256 durationDays
    ) public payable returns (uint256) {
        RLEnvironment storage env = environments[environmentId];
        require(env.pricePerCall > 0, "Environment does not exist");
        require(calls > 0, "Calls must be > 0");
        require(durationDays > 0, "Duration must be > 0");
        
        uint256 totalCost = calls * env.pricePerCall;
        require(msg.value >= totalCost, "Insufficient payment");
        
        uint256 subscriptionId = _subscriptionCounter++;
        subscriptions[subscriptionId] = Subscription({
            subscriber: msg.sender,
            environmentId: environmentId,
            callsRemaining: calls,
            expiryTime: block.timestamp + (durationDays * 1 days),
            pricePerCall: env.pricePerCall,
            active: true
        });
        
        env.totalCalls += calls;
        env.activeSubscriptions++;
        
        // 退款多余金额
        if (msg.value > totalCost) {
            (bool refundSuccess, ) = payable(msg.sender).call{value: msg.value - totalCost}("");
            require(refundSuccess, "Refund failed");
        }
        
        emit SubscriptionPurchased(subscriptionId, msg.sender, environmentId, calls, totalCost);
        return subscriptionId;
    }

    /**
     * @notice 执行 RL 调用（自动扣费）
     * @param subscriptionId 订阅 ID
     * @param inputData 输入数据（ABI 编码）
     */
    function executeRLCall(uint256 subscriptionId, bytes calldata inputData) 
        external 
        returns (bytes memory result) 
    {
        Subscription storage sub = subscriptions[subscriptionId];
        require(sub.active, "Subscription not active");
        require(sub.subscriber == msg.sender, "Not subscriber");
        require(sub.callsRemaining > 0, "No calls remaining");
        require(block.timestamp < sub.expiryTime, "Subscription expired");
        
        // 扣费
        sub.callsRemaining--;
        uint256 cost = sub.pricePerCall;
        
        RLEnvironment storage env = environments[sub.environmentId];
        
        // 支付给环境所有者
        (bool paymentSuccess, ) = payable(env.owner).call{value: cost}("");
        require(paymentSuccess, "Payment failed");
        
        emit CallExecuted(subscriptionId, block.timestamp, cost);
        emit CallCharged(subscriptionId, msg.sender, env.owner, cost);
        
        // 实际调用 RL 环境（这里简化为返回输入数据）
        // 实际实现应该调用 RL 环境合约
        result = inputData;
        
        return result;
    }

    /**
     * @notice 获取订阅信息
     * @param subscriptionId 订阅 ID
     */
    function getSubscription(uint256 subscriptionId) public view returns (Subscription memory) {
        return subscriptions[subscriptionId];
    }

    /**
     * @notice 获取环境信息
     * @param environmentId 环境 ID
     */
    function getEnvironment(uint256 environmentId) public view returns (RLEnvironment memory) {
        return environments[environmentId];
    }

    /**
     * @notice 取消订阅（不退款）
     * @param subscriptionId 订阅 ID
     */
    function cancelSubscription(uint256 subscriptionId) public {
        Subscription storage sub = subscriptions[subscriptionId];
        require(sub.subscriber == msg.sender, "Not subscriber");
        require(sub.active, "Already cancelled");
        
        sub.active = false;
        environments[sub.environmentId].activeSubscriptions--;
    }

    /**
     * @notice 提取合约余额（仅环境所有者）
     */
    function withdraw() public {
        // 环境所有者可以提取收入
        // 实际实现需要跟踪每个所有者的收入
    }
}
