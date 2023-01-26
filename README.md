
# forDem برای مردم‌گردانی
## A censorship-resistant e-Democracy platform  
forDem, an abbreviation of ‘for Democracy’, is an open source (AGPL v3) cross-platform e-democracy and socio-political mobilization app, with participation, deliberation, and networking functionalities. It forms P2P networks over the internet and ‘WiFi-Direct’ mesh. forDem respects privacy and is oriented on data security. It is an inter-connected app in the ‘Fediverse’ and beyond.  
The aim of forDem is to be the main channel between social struggles and discussions in societies and it is there to make the voice of civil society movements heard and to maximize their impact.  
  
To bring the project to life, different actors from across the globe are involved, including tech companies, research institutions, and non-profit organizations.  
  
  
  
Check the [`Feature List`](https://github.com/tcfev/forDem/issues/85)  
Want to Join?: [`check here`](https://github.com/tcfev/forDem/issues/61)  & [`this discussion`](https://github.com/tcfev/forDem/discussions/52)  
`In case you have privacy concerns, create a new Github account first and then write to us or engage in discussions.`  
[`Project Documentation`](https://github.com/tcfev/forDem-documentation) will help you understand how we organise the project. (Work in progress)
#
This repository is where we organise the 3 main components of the platform:
* [Backend](https://github.com/tcfev/fordem-backend)
* [Mobile App](https://github.com/tcfev/fordem-app)
* [Website](https://github.com/tcfev/fordem-website)
#
* [Organisation's flowchart](https://github.com/tcfev/forDem/blob/main/.assets/organisation.md) - WIP
* [Our Values & principles](https://github.com/tcfev/forDem/issues/57)
* [Protocols](https://github.com/tcfev/forDem/tree/main/.assets/.protocols)
#
**Platforms**
- Android
- iOS
- Web
- Linux, Windows and MacOS
#
**Connected APIs**
- ActivityPub (Compatible with the Fediverse)
#
**UI Design**  
* [Figma design](https://www.figma.com/file/VHFRoqXfhc2ThZQMZUXcje/%D8%A8%D8%B1%D8%A7%DB%8C-%D9%85%D8%B1%D8%AF%D9%85%E2%80%8C%D8%B3%D8%A7%D9%84%D8%A7%D8%B1%DB%8C%2Ff%C3%BCrDem?node-id=0%3A1)  
* [UX-flowchart](https://github.com/tcfev/forDem/blob/main/.assets/ux-flowchart.md) - work-in-progress
* [Brand-identity](https://github.com/tcfev/forDem/blob/main/.assets/brand-identity.md) - work-in-progress  
#
**Domain model - todo**  
#
**Standards - todo**  
- `Suggestion` for user-centred design processes and extension of UI/UX concept
    * `ISO 13407:1999.`
- `Suggestion` for design of the system architecture
    * `ISO/IEC 25010:2011, CD 25019.3`
---
**e-Democracy platforms and how forDem stands out**  

Every e-Democracy platform must have the following four core functionlities/features fully fledged in it: 
- `Transparency`
- `Networking`
- `Deliberation`
- `Participation`

**This makes forDem unique:**  
* Next to the four core pillars mentioned above forDem will offer `peer-to-peer connectivity`, `decentralised storage` & `onion-routing`.
---
#### Platform architecture
![img](https://github.com/tcfev/forDem/blob/main/.assets/Fordem%20Architecture-Architecture.drawio.png)

---
#### P2P, DHT & Synchronization
We have two main parts that relate to P2P functionalities  
- P2P mode  
- Local NoSQL database  
  
Once there is no internet connection available (and the app is set to discover mesh networks/other peers), if P2P connection is established, the local databases of the adjacent apps will be compared and synchronised. This can happen through a comparison of the lists of keys(UUIDs) of the two databases, and if there is a difference, a union of the differing key:values will be shared between the two apps. Goal here is to send as small yet meaningful pieces of data as the Mesh network can handle.  
Here are the mesh protocol’s specification and situation of the peers, the defining factor.  
If the network is healthy, the size of the chunk of data that is going to be shared, increases.  
In version one synchronisation takes place between the databases of each two apps (with intermediary nodes or without) that have differing tables. In later versions, a more efficient method will be chosen.  
One main goal is to regularly check & report the level of synchronicity until the network is stabilised and all the data is available on all apps. However smaller chunks of fully synchronised data (individual entities) are still valuable.  
So, long story short, synchronising the NoSQL databases of peers in the most efficient way is the goal. 
  
![img](https://github.com/tcfev/forDem/blob/main/.assets/forDem-P2P-DHT-Diagramm.drawio.png)

---

## Roadmap
**internet**
 - Mastadon compatibility API: A gRPC server written C# with REST extension compatible with Mastadon's REST API
 - Port/Extend Mastadon's REST API with new features implemented in C# (as a micro service) 
- Generate Frontend
	 - Generate client-side API
	 -  (optional) generate UI for Flutter - just a scaffold. UI Dev can then customize this.

**P2P**

- Embedd NewNode (Android)
- Embedd NewNode (iOS)
- Couple client-side APIs

**synchronization (DHT)** - todo

---
¹ Organizations/networks/individuals that are consistant with values around human rights and UN development goals. Also see: [Our Values & principles](https://github.com/tcfev/forDem/issues/57)

