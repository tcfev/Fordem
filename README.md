# For Democracy

Fordem is a digital democracy platform designed to make collective decision-making more engaging, flexible, accessible, and effective.  
It combines zero-knowledge proof of identity, computational social choice for collective decision-making, decentralized financial instrument and services, and artificial intelligence to facilitate community building, organization, and mobilization.


## Architecture


```mermaid
flowchart TD
    System[Fordem] --> DDP[Digital Democracy Platform]
    System --> DCB[Decentralized Banking]
    System --> MP[Marketplace]
    System --> ZKIdentity[ZK Proof of Identity]
    
    DDP --> Voting[Voting]
    DDP --> Forum[Forum]
    Forum --> Deliberation[Deliberation]
    Forum --> Discussion[Discussion]
    
    %% Computational Social Choice Methods
    
    DCB --> Fundraising[Fundraising]
    DCB --> Transfer[Transfer]
    
    MP --> AskOrOfferService[Ask/Offer a Service]
    
    %% ZK Identity enables voting, banking, deliberation, and forum access
    ZKIdentity -.-> DDP
    ZKIdentity -.-> MP
    ZKIdentity -.-> DCB
    Voting -.-> DCB    

    
    %% Styling
    classDef ddpStyle fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef dcbStyle fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef mpStyle fill:#e8f5e8,stroke:#1b5e20,stroke-width:2px
    classDef votingStyle fill:#fff3e0,stroke:#e65100,stroke-width:2px
    classDef systemStyle fill:#fce4ec,stroke:#880e4f,stroke-width:2px
    
    class System systemStyle
    class DDP,Forum,Deliberation,Discussion,ZKIdentity ddpStyle
    class DCB,Loans,Fundraising,Transfer,Swap,DCBActivation dcbStyle
    class MP,PostJob,OfferService mpStyle
    class Voting,RankedPairs,Approval votingStyle
```