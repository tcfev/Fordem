# For Governed To Govern

Fordem is a digital democracy platform designed to make collective decision-making more engaging, flexible, accessible, and effective.  
It combines zero-knowledge proof of identity, computational social choice for collective decision-making, decentralized financial instrument and services, and artificial intelligence to facilitate community building, organization, and mobilization.


```mermaid
flowchart TD
    System[Fordem] --> DDP[Digital Democracy Platform]
    System --> DCB[Decentralized Finance]
    System --> MP[Market Place]
    System --> ZKIdentity[ZK Proof of Identity]
    
    DDP --> DecisionMaking[Vote]
    DDP --> Deliberation[Deliberate]
    
    DCB --> Fundraising[Fundraising]
    DCB --> Transfer[Transfer]
    
    MP --> AskOrOfferService[Request/Offer Services]

    ZKIdentity -.-> DDP
    ZKIdentity -.-> DCB
    ZKIdentity -.-> MP
    DecisionMaking -.-> DCB    


    %% Styling
    classDef ddpStyle fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef dcbStyle fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef mpStyle fill:#e8f5e8,stroke:#1b5e20,stroke-width:2px
    
    class DDP,Deliberation,DecisionMaking ddpStyle
    class DCB,Fundraising,Transfer, dcbStyle
    class MP,AskOrOfferService mpStyle

```