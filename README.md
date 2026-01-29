Catadupa de Equações - NFT Collection - Smart Contracts
This repository contains the On-Chain logic for the "Catadupa de Equações - NFT Collection" project, a robust Proof of Concept (PoC) designed to demonstrate seamless integration between Java Enterprise systems and Blockchain technology.

🏛️ System Architecture
The project follows a Hybrid Architecture to ensure security, scalability, and business process compliance:

On-Chain Layer (This Repository):
Developed in Solidity.
Implements the ERC-1155 standard on the Polygon network for cost-efficiency.
Manages immutability, ownership, and asset transfers (NFTs/RWAs).

Off-Chain Layer (Middleware):
Java Enterprise backend acting as the central orchestrator.
Handles business logic, scheduling, and secure Blockchain communication via Web3j.

🚀 Key Features
Dynamic Minting: Support for creating new editions (Monthly Drops) without requiring contract redeployments.
Gas Efficiency: Optimized for low-cost transactions on the Polygon network.
Role-Based Access Control (RBAC): Only the authorized Java Orchestrator address has permission to trigger minting, ensuring centralized control over issuance.

🛠️ Tech Stack
Language: Solidity ^0.8.20
Network: Polygon
Standard: OpenZeppelin ERC-1155
