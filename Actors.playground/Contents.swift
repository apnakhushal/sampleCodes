import UIKit

actor Account {
    let accountNumber: String = "IBAN..." // A constant, non-isolated property
    var balance: Int = 20 // current user balance

    nonisolated func getMaskedAccountNumber() -> String {
        return String.init(repeating: "*", count: 12) + accountNumber.suffix(4)
    }
    
    // no need to mention `async` here
    func withdraw(amount: Int) {
        guard balance >= amount else {
            print("withdawal rejected - insufficient balance")
            return
        }
        self.balance = balance - amount
        print("withdawal succesfully - updated balance -> \(balance)")
    }
}

actor TransactionManager {
    let account: Account
    
    init(account: Account) {
        self.account = account
    }
    
    func performWithdrawal(amount: Int) async {
        await account.withdraw(amount: amount)
    }
}

// Usage
var myAccount = Account()
let manager = TransactionManager(account: myAccount)
let accountNumber = myAccount.accountNumber
let maskedAccountNumber = myAccount.getMaskedAccountNumber()

// Perform a withdrawal from TransactionManager Actor
Task {
    // cross-actor reference
    // 'possible' suspension point.
    await manager.performWithdrawal(amount: 10)
}

// Perform a withdrawal from outside any actor
Task {
    // cross-actor reference
    await myAccount.withdraw(amount: 25)
}



// MARK: TaskGroups

func fetchThumbnails(urls: [URL]?) async throws -> [UIImage] {
    guard let urls else { return [] }
    return try await withThrowingTaskGroup(of: UIImage.self) { group in
        for url in urls {
            group.addTask {
                // Fetch and return a UIImage
                let (data, _) = try await URLSession.shared.data(from: url)
                return UIImage(data: data) ?? UIImage()
            }
        }

        var results: [UIImage] = []
        // Iterate over results as they complete (order is not guaranteed)
        for try await result in group {
            results.append(result)
        }
        return results
    }
}

let dummyURLs = [
    URL(string: "https://picsum.photos/200/300")!,
    URL(string: "https://picsum.photos/seed/picsum/200/300")!,
    URL(string: "https://picsum.photos/id/237/200/300")!,
    URL(string: "https://placehold.jp")!,
    URL(string: "https://placehold.jp")!
]

Task {
    do {
        let thumbnails = try await fetchThumbnails(urls: dummyURLs)
        print("Successfully fetched \(thumbnails.count) images.")
        
        // Example: Use the first image
        if let lastImage = thumbnails.first {
            // Update your UI on the Main Thread if needed
            await MainActor.run {
                print(lastImage)
                // self.imageView.image = firstImage
            }
        }
    } catch {
        print("Failed to fetch thumbnails: \(error.localizedDescription)")
    }
}

