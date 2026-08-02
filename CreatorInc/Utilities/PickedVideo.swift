//
//  PickedVideo.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 01/08/2026.
//


//moves videos from phones storage to apps storage

import Foundation       // gives us FileManager, UUID, URL
import CoreTransferable // gives us the Transferable protocol
import UniformTypeIdentifiers

struct PickedVideo: Transferable {
    let url: URL // where our copy of the picked video lives on disk

    static var transferRepresentation: some TransferRepresentation {
        // tells PhotosPicker: "when a video comes in, run this closure to receive it"
        FileRepresentation(importedContentType: .movie) { received in
            // pick a new, unique file path in our app's temp folder
            let copy = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".mov")
            // copy the picked video from its temporary system location to our own file
            try FileManager.default.copyItem(at: received.file, to: copy)
            // hand back a PickedVideo pointing at our own copy
            return PickedVideo(url: copy)
        }
    }
}

