import PlaydateKit
import PDUIKit

nonisolated(unsafe) var game: Game!
@_cdecl("eventHandler") func eventHandler(
    pointer: UnsafeMutablePointer<PlaydateAPI>,
    event: System.Event,
    arg _: CUnsignedInt
) -> CInt {
    switch event {
    case .initialize:
        Playdate.initialize(with: pointer)
        game = Game()
        System.updateCallback = game.update
    default: game.handle(event)
    }
    return 0
}

final class Game: PlaydateGame {
    let rootViewController: UIViewController

    init() {
        self.rootViewController = ViewController()
    }

    func update() -> Bool {
        rootViewController.update()
        return true
    }
}
