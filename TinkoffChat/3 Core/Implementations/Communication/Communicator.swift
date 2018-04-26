//
//  Communicator.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 05.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation
import MultipeerConnectivity

/// Структура кодируемого сообщения
private struct MessageStruct: Codable{
    /// Тип события
    let eventType: String
    /// Уникальный ID сообщения
    let messageId: String
    /// Текст сообщения
    let text: String
}

class TinkoffCommunicator: NSObject, Communicator, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate {
    
    /// ID текущего пира
    private let myPeerId: MCPeerID
    private let advertiser: MCNearbyServiceAdvertiser
    private let browser: MCNearbyServiceBrowser
    private var sessionsByDisplayName: [String: MCSession]
    private var peersByDesplayName: [String: (peerID: MCPeerID, info: [String: String]?)] = [:]
    
    var delegate: CommunicatorDataDelegate?
    var online: Bool
    
    /// Инициализатор
    init(userName: String) {
        // 1 этап
        self.myPeerId = MCPeerID(displayName: UIDevice.current.name)
        self.advertiser = MCNearbyServiceAdvertiser(peer: myPeerId,
                                                    discoveryInfo: ["userName": userName],
                                                    serviceType: "tinkoff-chat")
        self.browser = MCNearbyServiceBrowser(peer: myPeerId,
                                                     serviceType: "tinkoff-chat")
        self.sessionsByDisplayName = [:]
        self.online = true
        super.init()
        // 2 этап
        self.advertiser.delegate = self//delegate as? MCNearbyServiceAdvertiserDelegate
        self.browser.delegate = self//delegate as? MCNearbyServiceBrowserDelegate
        self.advertiser.startAdvertisingPeer()
        self.browser.startBrowsingForPeers()
        print("TinkoffCommunicator inited")
    }
    
    /// Деинициализатор
    deinit {
        self.advertiser.stopAdvertisingPeer()
        self.browser.stopBrowsingForPeers()
    }
    
    // MARK: -
    
    func sendMessage(text: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?) {
        delegate?.sendMessage(text: text, to: userID)
        if let session = sessionsByDisplayName[userID]{
            if let peer = peersByDesplayName[userID]?.0{
                let message = MessageStruct(eventType: "TextMessage", messageId: generateMessageId(), text: text)
                let jsonEncoder = JSONEncoder()
                do {
                    let data = try jsonEncoder.encode(message)
                    do {
                        try session.send(data, toPeers: [peer], with: .unreliable)
                        completionHandler?(true, nil)
                    } catch {
                        print("Сообщение отправить не удалось: \(text)")
                        completionHandler?(false, error)
                    }
                } catch {
                    print("Не удалось закодировать в формат JSON")
                    completionHandler?(false, error)
                }

            }
            
        }
        
    }
    
    /// Генерация уникального ID для сообщений
    private func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UInt32.max))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UInt32.max))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
    // MARK: - MCSessionDelegate
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        switch state {
        case .connecting: break
        case .connected: break
//            if let userName = peersByDesplayName[peerID.displayName]?.info?["userName"]{
//                delegate?.didFoundUser(userID: peerID.displayName, userName: userName)
//            }
        case .notConnected: break
        }
        
        switch state {
        case .connecting: print("ПИР \(peerID.displayName) ПОДКЛЮЧАЕТСЯ")
        case .connected: print("ПИР \(peerID.displayName) ПОДКЛЮЧИЛСЯ")
        case .notConnected: print("ПИР \(peerID.displayName) ОТКЛЮЧИЛСЯ")
        }
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let jsonDecoder = JSONDecoder()
        do{
            let message = try jsonDecoder.decode(MessageStruct.self, from: data)
            if message.eventType == "TextMessage" {
                print("Сообщение: \(message.text)")
                delegate?.didReceiveMessage(text: message.text, from: peerID.displayName)
            } else {
                print("Получен неизвестный тип события: \(message.eventType)")
            }
        }catch{
            print("Не удалось раскодировать формат JSON")
        }
        
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
    
    // MARK: - MCNearbyServiceAdvertiserDelegate
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        delegate?.failedToStartAdvertising(error: error)
        print("didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        print("ПОЛУЧЕНО ПРИГЛАШЕНИЕ ОТ \(peerID.displayName)")
        let session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        invitationHandler(true, session)
        print("ПРИНЯТО ПРИГЛАШЕНИЕ ОТ \(peerID.displayName)")
        if let userName = peersByDesplayName[peerID.displayName]?.info?["userName"]{
                delegate?.didFoundUser(userID: peerID.displayName, userName: userName)
        }
        sessionsByDisplayName[peerID.displayName] = session
    }
    
    // MARK: - MCNearbyServiceBrowserDelegate
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
        print("didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        peersByDesplayName[peerID.displayName] = (peerID, info)
        print("НАЙДЕН ПИР: \(peerID.displayName)")
        let session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        browser.invitePeer(peerID, to: session, withContext: generateMessageId().data(using: .utf8), timeout: 10)
        sessionsByDisplayName[peerID.displayName] = session
        let name = info?["userName"] ?? "unknown"
        delegate?.didFoundUser(userID: peerID.displayName, userName: name)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("ПОТЕРЯН ПИР \(peerID)")
        peersByDesplayName[peerID.displayName] = nil
        sessionsByDisplayName[peerID.displayName] = nil
        delegate?.didLostUser(userID: peerID.displayName)
    }

}

