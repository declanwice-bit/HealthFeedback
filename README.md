# 🌟 HealthFeedback: Transparent Patient Feedback System

Welcome to HealthFeedback, a Web3 project that revolutionizes healthcare by enabling patients to provide tokenized feedback on treatments. This creates transparent, aggregated data to improve global healthcare protocols, solving the real-world problem of opaque and siloed patient insights that hinder medical advancements. Built on the Stacks blockchain using Clarity smart contracts, it incentivizes honest feedback with tokens while ensuring privacy and immutability.

## ✨ Features

🔑 Anonymous patient registration with pseudonym handles  
📝 Token-gated feedback submission on specific treatments  
📊 Real-time aggregation of feedback data for protocol insights  
💰 Reward tokens for verified, high-quality contributions  
🛡️ Privacy-preserving data storage with zero-knowledge proofs  
🔄 Governance voting for protocol updates based on aggregated data  
📈 Analytics dashboard for healthcare providers (off-chain integration)  
🚫 Anti-spam measures to prevent fake feedback  

## 🛠 How It Works

HealthFeedback uses 8 Clarity smart contracts to manage the system securely on the Stacks blockchain. Here's a breakdown:

### Smart Contracts Overview

1. **FeedbackToken.clar**: An SIP-10 compliant fungible token contract for the native HFB token, handling minting, burning, and transfers to reward participants.
2. **PatientRegistry.clar**: Registers patients with anonymous pseudonyms, storing hashed identities to enable repeat feedback without revealing personal info.
3. **TreatmentCatalog.clar**: Maintains a decentralized database of treatment protocols, allowing additions via governance and referencing by IDs in feedback.
4. **FeedbackSubmission.clar**: Core contract for submitting feedback; requires staking HFB tokens, records ratings, comments (hashed for privacy), and links to treatments.
5. **DataAggregator.clar**: Aggregates feedback scores and sentiments per treatment, computing averages and trends immutably for transparent insights.
6. **RewardDistributor.clar**: Distributes HFB tokens to patients based on feedback quality (e.g., verified by community votes or oracle inputs).
7. **GovernanceDAO.clar**: Enables token holders to vote on updating healthcare protocols or adding new treatments, using quadratic voting for fairness.
8. **VerificationOracle.clar**: Integrates external oracles (via Stacks' capabilities) to validate feedback authenticity, preventing fraud with off-chain checks.

### For Patients

- Register anonymously via PatientRegistry.clar to get a pseudonym.
- Acquire HFB tokens (e.g., via airdrop or purchase).
- Stake tokens and call submit-feedback in FeedbackSubmission.clar with treatment ID, rating (1-5), and hashed comments.
- Earn rewards from RewardDistributor.clar if your feedback is aggregated and deemed valuable.

Your input helps build a global, transparent dataset!

### For Healthcare Providers & Researchers

- Query DataAggregator.clar to get aggregated stats on treatments (e.g., average efficacy scores).
- Use get-treatment-insights to view immutable data trends.
- Propose protocol improvements via GovernanceDAO.clar votes.

Instant access to crowd-sourced, tamper-proof feedback!

### For Token Holders

- Participate in governance to shape the platform.
- Stake HFB for rewards from the ecosystem's transaction fees.

This system ensures feedback is incentivized, aggregated transparently, and used to evolve healthcare protocols worldwide. Deploy on Stacks for low-cost, Bitcoin-secured transactions!