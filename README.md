
# forDem برای مردم‌گردانی
## A censorship-resistant e-Democracy platform  
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
* [UX-flowchart](https://github.com/tcfev/forDem/blob/main/.assets/ux-flowchart.md) - WIP
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
**P2P-DHT & Synchronisiation**  

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

