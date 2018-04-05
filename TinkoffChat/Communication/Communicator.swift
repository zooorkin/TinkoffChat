//
//  Communicator.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 05.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation
import MultipeerConnectivity


class TinkoffCommunicator: NSObject, Communicator, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate {
    
    private let myPeerId: MCPeerID
    private let advertiser: MCNearbyServiceAdvertiser
    private let browser: MCNearbyServiceBrowser
    private var sessions: [String: MCSession]
    private var peers: [String: (MCPeerID,[String: String]?)] = [:]
    
    var delegate: CommunicatorDelegate?
    var online: Bool
    
    init(userName: String) {
        // 1
        self.myPeerId = MCPeerID(displayName: userName)
        self.advertiser = MCNearbyServiceAdvertiser(peer: myPeerId,
                                                           discoveryInfo: ["userName": userName],
                                                           serviceType: "tinkoff-chat")
        self.browser = MCNearbyServiceBrowser(peer: myPeerId,
                                                     serviceType: "tinkoff-chat")
        self.sessions = [:]
        self.online = true
        super.init()
        // 2
        self.advertiser.delegate = self//delegate as? MCNearbyServiceAdvertiserDelegate
        self.browser.delegate = self//delegate as? MCNearbyServiceBrowserDelegate
        self.advertiser.startAdvertisingPeer()
        self.browser.startBrowsingForPeers()
        print("TinkoffCommunicator inited")
    }
    
    deinit {
        self.advertiser.stopAdvertisingPeer()
        self.browser.stopBrowsingForPeers()
    }
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        if let strongSession = sessions[userID]{
            if let peer = peers[userID]?.0{
                do{
                    try strongSession.send(string.data(using: .utf8)!, toPeers: [peer], with: .unreliable)
                }catch{
                    print("Сообщение отправить не удалось")
                }
            }
        }
    }
    
    private func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UInt32.max))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UInt32.max))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
    // MARK: -
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("ПИР \(peerID.displayName) ИЗМЕНИЛ СВОЁ СОСТОЯНИЕ НА \(state.rawValue)")
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let s = String.init(data: data, encoding: .utf8) ?? "nil"
        print("СООБЩЕНИЕ: \(s)")
        delegate?.didReceiveMessage(text: s, fromUser: peerID.displayName, toUser: myPeerId.displayName)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
    // MARK: -
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
                print("ПОЛУЧЕНО ПРИГЛАШЕНИЕ ОТ \(peerID)")
        let session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        sessions[peerID.displayName] = session
        if let strongSession = sessions[peerID.displayName]{
            invitationHandler(true, strongSession)
            print("ПРИНЯТО ПРИГЛАШЕНИЕ ОТ \(peerID.displayName)")
            if let info = peers[peerID.displayName]{
                if let strongInfo = info.1{
                    if let userName = strongInfo["userName"]{
                        delegate?.didFoundUser(userID: peerID.displayName, userName: userName)
                    }
                }
            }
        }
        
    }
    
    // MARK: -
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        peers[peerID.displayName] = (peerID, info)

        print("НАЙДЕН ПИР: \(peerID.displayName)")
        
        sessions[peerID.displayName] = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        if let strongSession = sessions[peerID.displayName]{
            strongSession.delegate = self
            browser.invitePeer(peerID, to: strongSession, withContext: generateMessageId().data(using: .utf8), timeout: 10)
            sessions[peerID.displayName] = strongSession
            if let strongInfo = info{
                if let userName = strongInfo["userName"]{
                    delegate?.didFoundUser(userID: peerID.displayName, userName: userName)
                }
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        peers[peerID.displayName] = nil
        sessions[peerID.displayName] = nil
        print("ПОТЕРЯН ПИР \(peerID)")
        delegate?.didLostUser(userID: peerID.displayName)
    }

}

