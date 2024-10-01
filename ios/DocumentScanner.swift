@available(iOS 13.0, *)
@objc(DocumentScanner)
class DocumentScanner: NSObject {

    @objc static func requiresMainQueueSetup() -> Bool {
        return true
    }

    let documentScanner = DocScanner()

    @objc(scanDocument:withResolver:withRejecter:)
    func scanDocument(
      _ options: NSDictionary,
      resolve: @escaping RCTPromiseResolveBlock,
      reject: @escaping RCTPromiseRejectBlock
    ) -> Void {
        DispatchQueue.main.async {
            // Extract maxNumDocuments from options
            let documentLimit = options["maxNumDocuments"] as? Int

            self.documentScanner.startScan(
                RCTPresentedViewController(),
                successHandler: { (scannedDocumentImages: [String]) in
                    resolve([
                        "status": "success",
                        "scannedImages": scannedDocumentImages
                    ])
                },
                errorHandler: { (errorMessage: String) in
                    reject("document scan error", errorMessage, nil)
                },
                cancelHandler: {
                    resolve(["status": "cancel"])
                },
                responseType: options["responseType"] as? String,
                croppedImageQuality: options["croppedImageQuality"] as? Int,
                documentLimit: documentLimit
            )
        }
    }
}
