import AppFoundation
import Observation
import SwiftUI

/// An observable owner for value navigation and a single sheet route.
@MainActor @Observable public final class NavigationRouter<Route: Hashable> {
    public var path: [Route] = []; public var sheet: Route?
    public init() {}
    public func show(_ route: Route) { path.append(route) }
    public func popToRoot() { path.removeAll() }
    public func prepare(deepLink routes: [Route]) { path = routes }
    public func presentSheet(_ route: Route) { sheet = route }
    public func dismissSheet() { sheet = nil }
}
