@attached(member, names: named(allKeyPaths))
@attached(extension, conformances: KeyPathIterable)
public macro KeyPathIterable() = #externalMacro(module: "KeyPathIterableMacrosPlugin", type: "KeyPathIterableMacro")
