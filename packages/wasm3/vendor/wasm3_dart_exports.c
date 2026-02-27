// Force-export wasm3 symbols from the shared library.
//
// On Windows/MSVC, DLL symbols are not exported unless explicitly declared
// via __declspec(dllexport) or linker pragmas. Wasm3 headers don't use
// dllexport, so we use #pragma comment(linker, ...) to add exports.
//
// On other platforms, shared library symbols are exported by default.

#ifdef _MSC_VER
#pragma comment(linker, "/export:m3_NewEnvironment")
#pragma comment(linker, "/export:m3_FreeEnvironment")
#pragma comment(linker, "/export:m3_NewRuntime")
#pragma comment(linker, "/export:m3_FreeRuntime")
#pragma comment(linker, "/export:m3_GetMemory")
#pragma comment(linker, "/export:m3_GetMemorySize")
#pragma comment(linker, "/export:m3_GetUserData")
#pragma comment(linker, "/export:m3_ParseModule")
#pragma comment(linker, "/export:m3_FreeModule")
#pragma comment(linker, "/export:m3_LoadModule")
#pragma comment(linker, "/export:m3_RunStart")
#pragma comment(linker, "/export:m3_LinkRawFunctionEx")
#pragma comment(linker, "/export:m3_FindFunction")
#pragma comment(linker, "/export:m3_Call")
#pragma comment(linker, "/export:m3_GetResults")
#pragma comment(linker, "/export:m3_GetArgCount")
#pragma comment(linker, "/export:m3_GetRetCount")
#pragma comment(linker, "/export:m3_GetRetType")
#pragma comment(linker, "/export:m3_GetArgType")
#pragma comment(linker, "/export:m3_GetFunctionName")
#pragma comment(linker, "/export:m3_GetErrorInfo")
#pragma comment(linker, "/export:m3_ResetErrorInfo")
#endif
