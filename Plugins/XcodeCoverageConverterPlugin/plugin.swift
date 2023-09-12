import Foundation
import PackagePlugin

@main
struct XcodeCoverageConverterPlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        let xccTool = try context.tool(named: "xcc")
        var arguments: [String] = ["generate"]
        arguments.append(contentsOf: ["--help"])
        
        let xccExec = URL(fileURLWithPath: xccTool.path.string)
        let process = try Process.run(xccExec, arguments: arguments)
        process.waitUntilExit()
        
        if process.terminationReason == .exit && process.terminationStatus == 0 {
            print("Converted the coverage report.")
        } else {
            let problem = "\(process.terminationReason):\(process.terminationStatus)"
            Diagnostics.error("xcc invocation failed: \(problem)")
        }
    }
}
