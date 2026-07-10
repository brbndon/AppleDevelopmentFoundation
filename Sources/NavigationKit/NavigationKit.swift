import Foundation
import Observation
import SwiftUI

/// An observable owner for value navigation and a single sheet route.
@MainActor @Observable public final class NavigationRouter<Route: Hashable> {
    /// The pushed routes in display order.
    public var path: [Route] = []

    /// The route currently presented as a sheet, if any.
    public var sheet: Route?

    /// Creates an empty router.
    public init() {}

    /// Pushes `route` onto the navigation path.
    public func show(_ route: Route) { path.append(route) }

    /// Removes every pushed route.
    public func popToRoot() { path.removeAll() }

    /// Replaces the path with routes parsed by the application from a deep link or restored state.
    public func prepare(deepLink routes: [Route]) { path = routes }

    /// Presents `route` in the router's sheet state.
    public func presentSheet(_ route: Route) { sheet = route }

    /// Clears the router's sheet state.
    public func dismissSheet() { sheet = nil }
}

public extension NavigationRouter where Route: Codable {
    /// Encodes the path for application-owned state restoration.
    func encodedPath() throws -> Data { try JSONEncoder().encode(path) }

    /// Restores the path from data previously returned by ``encodedPath()``.
    ///
    /// Invalid data throws the decoder's error and leaves the existing path unchanged.
    func restorePath(from data: Data) throws {
        let restoredPath = try JSONDecoder().decode([Route].self, from: data)
        path = restoredPath
    }
}
