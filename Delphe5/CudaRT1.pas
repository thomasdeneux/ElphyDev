unit CudaRT1;

interface

uses util1;


Const
  cudaMemcpyHostToHost = 0;
  cudaMemcpyHostToDevice = 1;
  cudaMemcpyDeviceToHost = 2;
  cudaMemcpyDeviceToDevice = 3;
  cudaMemcpyDefault = 4;

 

type
  cudaError_t = integer;
var
  cudaDeviceReset: function: cudaError_t;stdcall;

{*}  cudaDeviceSynchronize: function: cudaError_t;stdcall;
{*}  cudaDeviceSetLimit: function{ limit: integer; value: integer}: cudaError_t;stdcall;

{*}  cudaDeviceGetLimit: function{  var Value: integer; limit:integer}: cudaError_t;stdcall;
{*}  cudaDeviceGetCacheConfig: function{  var CacheConfig: integer}: cudaError_t;stdcall;

{*}  cudaDeviceSetCacheConfig: function{ cacheConfig: integer}: cudaError_t;stdcall;
{*}  cudaDeviceGetSharedMemConfig: function{  var Config:integer}: cudaError_t;stdcall;
{*}  cudaDeviceSetSharedMemConfig: function{ config: integer}: cudaError_t;stdcall;
{*}  cudaDeviceGetByPCIBusId: function{ var device: integer; pciBusId: Pchar}: cudaError_t;stdcall;
{*}  cudaDeviceGetPCIBusId: function{ pciBusId: Pchar; len, device: integer}: cudaError_t;stdcall;
{*}  cudaIpcGetEventHandle: function{ var handle: integer; cudaEvent_t event}: cudaError_t;stdcall;

{*}  cudaIpcOpenEventHandle: function{ cudaEvent_t *event, cudaIpcEventHandle_t handle}: cudaError_t;stdcall;
{*}  cudaIpcGetMemHandle: function{ cudaIpcMemHandle_t *handle, void *devPtr}: cudaError_t;stdcall;

{*}  cudaIpcOpenMemHandle: function{ void **devPtr, cudaIpcMemHandle_t handle, unsigned int flags}: cudaError_t;stdcall;

{*}  cudaIpcCloseMemHandle: function{ void *devPtr}: cudaError_t;stdcall;
{*}  cudaThreadExit: function{ void}: cudaError_t;stdcall;
{*}  cudaThreadSynchronize: function{ void}: cudaError_t;stdcall;

{*}  cudaThreadSetLimit: function{ enum cudaLimit limit, size_t value}: cudaError_t;stdcall;
{*}  cudaThreadGetLimit: function{ size_t *pValue, enum cudaLimit limit}: cudaError_t;stdcall;

{*}  cudaThreadGetCacheConfig: function{ enum cudaFuncCache *pCacheConfig}: cudaError_t;stdcall;

{*}  cudaThreadSetCacheConfig: function{ enum cudaFuncCache cacheConfig}: cudaError_t;stdcall;
{*}  cudaGetLastError: function{ void}: cudaError_t;stdcall;
{*}  cudaPeekAtLastError: function{ void}: cudaError_t;stdcall;

  cudaGetErrorString: function( error: cudaError_t): Pchar;stdcall;
  cudaGetDeviceCount: function( var count:integer): cudaError_t;stdcall;

{*}  cudaGetDeviceProperties: function{ struct cudaDeviceProp *prop, int device}: cudaError_t;stdcall;
{*}  cudaDeviceGetAttribute: function{ int *value, enum cudaDeviceAttr attr, int device}: cudaError_t;stdcall;
{*}  cudaChooseDevice: function{ int *device, const struct cudaDeviceProp *prop}: cudaError_t;stdcall;
{*}  cudaSetDevice: function{ int device}: cudaError_t;stdcall;
{*}  cudaGetDevice: function{ int *device}: cudaError_t;stdcall;
{*}  cudaSetValidDevices: function{ int *device_arr, int len}: cudaError_t;stdcall;
{*}  cudaSetDeviceFlags: function{  unsigned int flags }: cudaError_t;stdcall;
{*}  cudaStreamCreate: function{ cudaStream_t *pStream}: cudaError_t;stdcall;
{*}  cudaStreamCreateWithFlags: function{ cudaStream_t *pStream, unsigned int flags}: cudaError_t;stdcall;
{*}  cudaStreamDestroy: function{ cudaStream_t stream}: cudaError_t;stdcall;
{*}  cudaStreamWaitEvent: function{ cudaStream_t stream, cudaEvent_t event, unsigned int flags}: cudaError_t;stdcall;
{*}  cudaStreamAddCallback: function{ cudaStream_t stream}: cudaError_t;stdcall;
{*}  cudaStreamSynchronize: function{ cudaStream_t stream}: cudaError_t;stdcall;
{*}  cudaStreamQuery: function{ cudaStream_t stream}: cudaError_t;stdcall;
{*}  cudaEventCreate: function{ cudaEvent_t *event}: cudaError_t;stdcall;
{*}  cudaEventCreateWithFlags: function{ cudaEvent_t *event, unsigned int flags}: cudaError_t;stdcall;
{*}  cudaEventRecord: function{ cudaEvent_t event, cudaStream_t stream __dv}: cudaError_t;stdcall;
{*}  cudaEventQuery: function{ cudaEvent_t event}: cudaError_t;stdcall;
{*}  cudaEventSynchronize: function{ cudaEvent_t event}: cudaError_t;stdcall;
{*}  cudaEventDestroy: function{ cudaEvent_t event}: cudaError_t;stdcall;
{*}  cudaEventElapsedTime: function{ float *ms, cudaEvent_t start, cudaEvent_t end}: cudaError_t;stdcall;
{*}  cudaConfigureCall: function{ dim3 gridDim, dim3 blockDim, size_t sharedMem __dv, cudaStream_t stream __dv(}: cudaError_t;stdcall;
{*}  cudaSetupArgument: function{ const void *arg, size_t size, size_t offset}: cudaError_t;stdcall;
{*}  cudaFuncSetCacheConfig: function{ const void *func, enum cudaFuncCache cacheConfig}: cudaError_t;stdcall;
{*}  cudaFuncSetSharedMemConfig: function{ const void *func, enum cudaSharedMemConfig config}: cudaError_t;stdcall;
{*}  cudaLaunch: function{ const void *func}: cudaError_t;stdcall;
{*}  cudaFuncGetAttributes: function{ struct cudaFuncAttributes *attr, const void *func}: cudaError_t;stdcall;
{*}  cudaSetDoubleForDevice: function{ double *d}: cudaError_t;stdcall;
{*}  cudaSetDoubleForHost: function{ double *d}: cudaError_t;stdcall;

  cudaMalloc: function(var devPtr:pointer; size:integer): cudaError_t;stdcall;

{*}  cudaMallocHost: function{ void **ptr, size_t size}: cudaError_t;stdcall;
{*}  cudaMallocPitch: function{ void **devPtr, size_t *pitch, size_t width, size_t height}: cudaError_t;stdcall;
{*}  cudaMallocArray: function{ cudaArray_t *array, const struct cudaChannelFormatDesc *desc, size_t width, size_t height __dv( 0), unsigned int flags __dv( 0)}: cudaError_t;stdcall;

  cudaFree: function( var devPtr: pointer): cudaError_t;stdcall;

{*}  cudaFreeHost: function{ void *ptr}: cudaError_t;stdcall;
{*}  cudaFreeArray: function{ cudaArray_t array}: cudaError_t;stdcall;
{*}  cudaFreeMipmappedArray: function{ cudaMipmappedArray_t mipmappedArray}: cudaError_t;stdcall;
{*}  cudaHostAlloc: function{ void **pHost, size_t size, unsigned int flags}: cudaError_t;stdcall;
{*}  cudaHostRegister: function{ void *ptr, size_t size, unsigned int flags}: cudaError_t;stdcall;
{*}  cudaHostUnregister: function{ void *ptr}: cudaError_t;stdcall;
{*}  cudaHostGetDevicePointer: function{ void **pDevice, void *pHost, unsigned int flags}: cudaError_t;stdcall;
{*}  cudaHostGetFlags: function{ unsigned int *pFlags, void *pHost}: cudaError_t;stdcall;
{*}  cudaMalloc3D: function{ struct cudaPitchedPtr* pitchedDevPtr, struct cudaExtent extent}: cudaError_t;stdcall;
{*}  cudaMalloc3DArray: function{ cudaArray_t *array, const struct cudaChannelFormatDesc* desc, struct cudaExtent extent, unsigned int flags __dv}: cudaError_t;stdcall;
{*}  cudaMallocMipmappedArray: function{ cudaMipmappedArray_t *mipmappedArray, const struct cudaChannelFormatDesc* desc, struct cudaExtent extent, unsigned int numLevels, unsigned int flags __dv}: cudaError_t;stdcall;
{*}  cudaGetMipmappedArrayLevel: function{ cudaArray_t *levelArray, cudaMipmappedArray_const_t mipmappedArray, unsigned int level}: cudaError_t;stdcall;
{*}  cudaMemcpy3D: function{ const struct cudaMemcpy3DParms *p}: cudaError_t;stdcall;
{*}  cudaMemcpy3DPeer: function{ const struct cudaMemcpy3DPeerParms *p}: cudaError_t;stdcall;
{*}  cudaMemcpy3DAsync: function{ const struct cudaMemcpy3DParms *p, cudaStream_t stream __dv}: cudaError_t;stdcall;
{*}  cudaMemcpy3DPeerAsync: function{ const struct cudaMemcpy3DPeerParms *p, cudaStream_t stream __dv}: cudaError_t;stdcall;
{*}  cudaMemGetInfo: function{ size_t *free, size_t *total}: cudaError_t;stdcall;
{*}  cudaArrayGetInfo: function{ struct cudaChannelFormatDesc *desc, struct cudaExtent *extent, unsigned int *flags, cudaArray_t array}: cudaError_t;stdcall;

  cudaMemcpy: function(  dst:pointer; src:pointer; count, kind:integer): cudaError_t;stdcall;

{*}  cudaMemcpyPeer: function{ void *dst, int dstDevice, const void *src, int srcDevice, size_t count}: cudaError_t;stdcall;
{*}  cudaMemcpyToArray: function{ cudaArray_t dst, size_t wOffset, size_t hOffset, const void *src, size_t count, enum cudaMemcpyKind kind}: cudaError_t;stdcall;
{*}  cudaMemcpyFromArray: function{ void *dst, cudaArray_const_t src, size_t wOffset, size_t hOffset, size_t count, enum cudaMemcpyKind kind}: cudaError_t;stdcall;
{*}  cudaMemcpyArrayToArray: function{ cudaArray_t dst, size_t wOffsetDst, size_t hOffsetDst, cudaArray_const_t src, size_t wOffsetSrc, size_t hOffsetSrc, size_t count, enum cudaMemcpyKind kind __dv cudaMemcpyDeviceToDevice}: cudaError_t;stdcall;
{*}  cudaMemcpy2D: function{ void *dst, size_t dpitch, const void *src, size_t spitch, size_t width, size_t height, enum cudaMemcpyKind kind}: cudaError_t;stdcall;
{*}  cudaMemcpy2DToArray: function{ cudaArray_t dst, size_t wOffset, size_t hOffset, const void *src, size_t spitch, size_t width, size_t height, enum cudaMemcpyKind kind}: cudaError_t;stdcall;
{*}  cudaMemcpy2DFromArray: function{ void *dst, size_t dpitch, cudaArray_const_t src, size_t wOffset, size_t hOffset, size_t width, size_t height, enum cudaMemcpyKind kind}: cudaError_t;stdcall;
{*}  cudaMemcpy2DArrayToArray: function{ cudaArray_t dst, size_t wOffsetDst, size_t hOffsetDst, cudaArray_const_t src, size_t wOffsetSrc, size_t hOffsetSrc, size_t width, size_t height, enum cudaMemcpyKind kind __dvcudaMemcpyDeviceToDevice}: cudaError_t;stdcall;
{*}  cudaMemcpyToSymbol: function{ const void *symbol, const void *src, size_t count, size_t offset __dv, enum cudaMemcpyKind kind __dv cudaMemcpyHostToDevice}: cudaError_t;stdcall;
{*}  cudaMemcpyFromSymbol: function{ void *dst, const void *symbol, size_t count, size_t offset __dv, enum cudaMemcpyKind kind __dv cudaMemcpyDeviceToHost}: cudaError_t;stdcall;
{*}  cudaMemcpyAsync: function{ void *dst, const void *src, size_t count, enum cudaMemcpyKind kind, cudaStream_t stream __dv}: cudaError_t;stdcall;
{*}  cudaMemcpyPeerAsync: function{ void *dst, int dstDevice, const void *src, int srcDevice, size_t count, cudaStream_t stream __dv}: cudaError_t;stdcall;
{*}  cudaMemcpyToArrayAsync: function{ cudaArray_t dst, size_t wOffset, size_t hOffset, const void *src, size_t count, enum cudaMemcpyKind kind, cudaStream_t stream __dv}: cudaError_t;stdcall;
{*}  cudaMemcpyFromArrayAsync: function{ void *dst, cudaArray_const_t src, size_t wOffset, size_t hOffset, size_t count, enum cudaMemcpyKind kind, cudaStream_t stream __dv}: cudaError_t;stdcall;
{*}  cudaMemcpy2DAsync: function{ void *dst, size_t dpitch, const void *src, size_t spitch, size_t width, size_t height, enum cudaMemcpyKind kind, cudaStream_t stream __dv}: cudaError_t;stdcall;
{*}  cudaMemcpy2DToArrayAsync: function{ cudaArray_t dst, size_t wOffset, size_t hOffset, const void *src, size_t spitch, size_t width, size_t height, enum cudaMemcpyKind kind, cudaStream_t stream __dv}: cudaError_t;stdcall;
{*}  cudaMemcpy2DFromArrayAsync: function{ void *dst, size_t dpitch, cudaArray_const_t src, size_t wOffset, size_t hOffset, size_t width, size_t height, enum cudaMemcpyKind kind, cudaStream_t stream __dv}: cudaError_t;stdcall;
{*}  cudaMemcpyToSymbolAsync: function{ const void *symbol, const void *src, size_t count, size_t offset, enum cudaMemcpyKind kind, cudaStream_t stream __dv}: cudaError_t;stdcall;
{*}  cudaMemcpyFromSymbolAsync: function{ void *dst, const void *symbol, size_t count, size_t offset, enum cudaMemcpyKind kind, cudaStream_t stream __dv}: cudaError_t;stdcall;

  cudaMemset: function(  devPtr: pointer; value,count:integer): cudaError_t;stdcall;

{*}  cudaMemset2D: function{ void *devPtr, size_t pitch, int value, size_t width, size_t height}: cudaError_t;stdcall;
{*}  cudaMemset3D: function{ struct cudaPitchedPtr pitchedDevPtr, int value, struct cudaExtent extent}: cudaError_t;stdcall;
{*}  cudaMemsetAsync: function{ void *devPtr, int value, size_t count, cudaStream_t stream __dv}: cudaError_t;stdcall;
{*}  cudaMemset2DAsync: function{ void *devPtr, size_t pitch, int value, size_t width, size_t height, cudaStream_t stream __dv}: cudaError_t;stdcall;
{*}  cudaMemset3DAsync: function{ struct cudaPitchedPtr pitchedDevPtr, int value, struct cudaExtent extent, cudaStream_t stream __dv}: cudaError_t;stdcall;
{*}  cudaGetSymbolAddress: function{ void **devPtr, const void *symbol}: cudaError_t;stdcall;
{*}  cudaGetSymbolSize: function{ size_t *size, const void *symbol}: cudaError_t;stdcall;
{*}  cudaPointerGetAttributes: function{ struct cudaPointerAttributes *attributes, const void *ptr}: cudaError_t;stdcall;
{*}  cudaDeviceCanAccessPeer: function{ int *canAccessPeer, int device, int peerDevice}: cudaError_t;stdcall;
{*}  cudaDeviceEnablePeerAccess: function{ int peerDevice, unsigned int flags}: cudaError_t;stdcall;
{*}  cudaDeviceDisablePeerAccess: function{ int peerDevice}: cudaError_t;stdcall;
{*}  cudaGraphicsUnregisterResource: function{ cudaGraphicsResource_t resource}: cudaError_t;stdcall;
{*}  cudaGraphicsResourceSetMapFlags: function{ cudaGraphicsResource_t resource, unsigned int flags}: cudaError_t;stdcall;
{*}  cudaGraphicsMapResources: function{ int count, cudaGraphicsResource_t *resources, cudaStream_t stream __dv}: cudaError_t;stdcall;
{*}  cudaGraphicsUnmapResources: function{ int count, cudaGraphicsResource_t *resources, cudaStream_t stream __dv}: cudaError_t;stdcall;
{*}  cudaGraphicsResourceGetMappedPointer: function{ void **devPtr, size_t *size, cudaGraphicsResource_t resource}: cudaError_t;stdcall;
{*}  cudaGraphicsSubResourceGetMappedArray: function{ cudaArray_t *array, cudaGraphicsResource_t resource, unsigned int arrayIndex, unsigned int mipLevel}: cudaError_t;stdcall;
{*}  cudaGraphicsResourceGetMappedMipmappedArray: function{ cudaMipmappedArray_t *mipmappedArray, cudaGraphicsResource_t resource}: cudaError_t;stdcall;
{*}  cudaGetChannelDesc: function{ struct cudaChannelFormatDesc *desc, cudaArray_const_t array}: cudaError_t;stdcall;

//  cudaChannelFormatDesc: function { int x, int y, int z, int w, enum cudaChannelFormatKind f}: cudaError_t;stdcall;

{*}  cudaBindTexture: function{ size_t *offset, const struct textureReference *texref, const void *devPtr, const struct cudaChannelFormatDesc *desc, size_t size __dv UINT_MAX}: cudaError_t;stdcall;
{*}  cudaBindTexture2D: function{ size_t *offset, const struct textureReference *texref, const void *devPtr, const struct cudaChannelFormatDesc *desc, size_t width, size_t height, size_t pitch}: cudaError_t;stdcall;
{*}  cudaBindTextureToArray: function{ const struct textureReference *texref, cudaArray_const_t array, const struct cudaChannelFormatDesc *desc}: cudaError_t;stdcall;
{*}  cudaBindTextureToMipmappedArray: function{ const struct textureReference *texref, cudaMipmappedArray_const_t mipmappedArray, const struct cudaChannelFormatDesc *desc}: cudaError_t;stdcall;
{*}  cudaUnbindTexture: function{ const struct textureReference *texref}: cudaError_t;stdcall;
{*}  cudaGetTextureAlignmentOffset: function{ size_t *offset, const struct textureReference *texref}: cudaError_t;stdcall;
{*}  cudaGetTextureReference: function{ const struct textureReference **texref, const void *symbol}: cudaError_t;stdcall;
{*}  cudaBindSurfaceToArray: function{ const struct surfaceReference *surfref, cudaArray_const_t array, const struct cudaChannelFormatDesc *desc}: cudaError_t;stdcall;
{*}  cudaGetSurfaceReference: function{ const struct surfaceReference **surfref, const void *symbol}: cudaError_t;stdcall;
{*}  cudaCreateTextureObject: function{ cudaTextureObject_t *pTexObject, const struct cudaResourceDesc *pResDesc, const struct cudaTextureDesc *pTexDesc, const struct cudaResourceViewDesc *pResViewDesc}: cudaError_t;stdcall;
{*}  cudaDestroyTextureObject: function{ cudaTextureObject_t texObject}: cudaError_t;stdcall;
{*}  cudaGetTextureObjectResourceDesc: function{ struct cudaResourceDesc *pResDesc, cudaTextureObject_t texObject}: cudaError_t;stdcall;
{*}  cudaGetTextureObjectTextureDesc: function{ struct cudaTextureDesc *pTexDesc, cudaTextureObject_t texObject}: cudaError_t;stdcall;
{*}  cudaGetTextureObjectResourceViewDesc: function{ struct cudaResourceViewDesc *pResViewDesc, cudaTextureObject_t texObject}: cudaError_t;stdcall;
{*}  cudaCreateSurfaceObject: function{ cudaSurfaceObject_t *pSurfObject, const struct cudaResourceDesc *pResDesc}: cudaError_t;stdcall;
{*}  cudaDestroySurfaceObject: function{ cudaSurfaceObject_t surfObject}: cudaError_t;stdcall;
{*}  cudaGetSurfaceObjectResourceDesc: function{ struct cudaResourceDesc *pResDesc, cudaSurfaceObject_t surfObject}: cudaError_t;stdcall;
{*}  cudaDriverGetVersion: function{ int *driverVersion}: cudaError_t;stdcall;
{*}  cudaRuntimeGetVersion: function{ int *runtimeVersion}: cudaError_t;stdcall;
{*}  cudaGetExportTable: function{ const void **ppExportTable, const cudaUUID_t *pExportTableId}: cudaError_t;stdcall;


function InitCudaRT:boolean;

implementation



var
  hh:intG;

Const
  {$IFDEF Win64}
  DLLname1='cudaRT64_50_35.dll';
  {$ELSE}
  DLLname1='cudaRT32_50_35.dll';
  {$ENDIF}

procedure initCudaRT1;
begin
  cudaDeviceReset:=getProc(hh,'cudaDeviceReset',true);
  cudaDeviceSynchronize:=getProc(hh,'cudaDeviceSynchronize',true);
  cudaDeviceSetLimit:=getProc(hh,'cudaDeviceSetLimit',true);
  cudaDeviceGetLimit:=getProc(hh,'cudaDeviceGetLimit',true);
  cudaDeviceGetCacheConfig:=getProc(hh,'cudaDeviceGetCacheConfig',true);
  cudaDeviceSetCacheConfig:=getProc(hh,'cudaDeviceSetCacheConfig',true);
  cudaDeviceGetSharedMemConfig:=getProc(hh,'cudaDeviceGetSharedMemConfig',true);
  cudaDeviceSetSharedMemConfig:=getProc(hh,'cudaDeviceSetSharedMemConfig',true);
  cudaDeviceGetByPCIBusId:=getProc(hh,'cudaDeviceGetByPCIBusId',true);
  cudaDeviceGetPCIBusId:=getProc(hh,'cudaDeviceGetPCIBusId',true);
  cudaIpcGetEventHandle:=getProc(hh,'cudaIpcGetEventHandle',true);
  cudaIpcOpenEventHandle:=getProc(hh,'cudaIpcOpenEventHandle',true);
  cudaIpcGetMemHandle:=getProc(hh,'cudaIpcGetMemHandle',true);
  cudaIpcOpenMemHandle:=getProc(hh,'cudaIpcOpenMemHandle',true);
  cudaIpcCloseMemHandle:=getProc(hh,'cudaIpcCloseMemHandle',true);
  cudaThreadExit:=getProc(hh,'cudaThreadExit',true);
  cudaThreadSynchronize:=getProc(hh,'cudaThreadSynchronize',true);
  cudaThreadSetLimit:=getProc(hh,'cudaThreadSetLimit',true);
  cudaThreadGetLimit:=getProc(hh,'cudaThreadGetLimit',true);
  cudaThreadGetCacheConfig:=getProc(hh,'cudaThreadGetCacheConfig',true);
  cudaThreadSetCacheConfig:=getProc(hh,'cudaThreadSetCacheConfig',true);
  cudaGetLastError:=getProc(hh,'cudaGetLastError',true);
  cudaPeekAtLastError:=getProc(hh,'cudaPeekAtLastError',true);
  cudaGetErrorString:=getProc(hh,'cudaGetErrorString',true);
  cudaGetDeviceCount:=getProc(hh,'cudaGetDeviceCount',true);
  cudaGetDeviceProperties:=getProc(hh,'cudaGetDeviceProperties',true);
  cudaDeviceGetAttribute:=getProc(hh,'cudaDeviceGetAttribute',true);
  cudaChooseDevice:=getProc(hh,'cudaChooseDevice',true);
  cudaSetDevice:=getProc(hh,'cudaSetDevice',true);
  cudaGetDevice:=getProc(hh,'cudaGetDevice',true);
  cudaSetValidDevices:=getProc(hh,'cudaSetValidDevices',true);
  cudaSetDeviceFlags:=getProc(hh,'cudaSetDeviceFlags',true);
  cudaStreamCreate:=getProc(hh,'cudaStreamCreate',true);
  cudaStreamCreateWithFlags:=getProc(hh,'cudaStreamCreateWithFlags',true);
  cudaStreamDestroy:=getProc(hh,'cudaStreamDestroy',true);
  cudaStreamWaitEvent:=getProc(hh,'cudaStreamWaitEvent',true);
  cudaStreamAddCallback:=getProc(hh,'cudaStreamAddCallback',true);
  cudaStreamSynchronize:=getProc(hh,'cudaStreamSynchronize',true);
  cudaStreamQuery:=getProc(hh,'cudaStreamQuery',true);
  cudaEventCreate:=getProc(hh,'cudaEventCreate',true);
  cudaEventCreateWithFlags:=getProc(hh,'cudaEventCreateWithFlags',true);
  cudaEventRecord:=getProc(hh,'cudaEventRecord',true);
  cudaEventQuery:=getProc(hh,'cudaEventQuery',true);
  cudaEventSynchronize:=getProc(hh,'cudaEventSynchronize',true);
  cudaEventDestroy:=getProc(hh,'cudaEventDestroy',true);
  cudaEventElapsedTime:=getProc(hh,'cudaEventElapsedTime',true);
  cudaConfigureCall:=getProc(hh,'cudaConfigureCall',true);
  cudaSetupArgument:=getProc(hh,'cudaSetupArgument',true);
  cudaFuncSetCacheConfig:=getProc(hh,'cudaFuncSetCacheConfig',true);
  cudaFuncSetSharedMemConfig:=getProc(hh,'cudaFuncSetSharedMemConfig',true);
  cudaLaunch:=getProc(hh,'cudaLaunch',true);
  cudaFuncGetAttributes:=getProc(hh,'cudaFuncGetAttributes',true);
  cudaSetDoubleForDevice:=getProc(hh,'cudaSetDoubleForDevice',true);
  cudaSetDoubleForHost:=getProc(hh,'cudaSetDoubleForHost',true);
  cudaMalloc:=getProc(hh,'cudaMalloc',true);
  cudaMallocHost:=getProc(hh,'cudaMallocHost',true);
  cudaMallocPitch:=getProc(hh,'cudaMallocPitch',true);
  cudaMallocArray:=getProc(hh,'cudaMallocArray',true);
  cudaFree:=getProc(hh,'cudaFree',true);
  cudaFreeHost:=getProc(hh,'cudaFreeHost',true);
  cudaFreeArray:=getProc(hh,'cudaFreeArray',true);
  cudaFreeMipmappedArray:=getProc(hh,'cudaFreeMipmappedArray',true);
  cudaHostAlloc:=getProc(hh,'cudaHostAlloc',true);
  cudaHostRegister:=getProc(hh,'cudaHostRegister',true);
  cudaHostUnregister:=getProc(hh,'cudaHostUnregister',true);
  cudaHostGetDevicePointer:=getProc(hh,'cudaHostGetDevicePointer',true);
  cudaHostGetFlags:=getProc(hh,'cudaHostGetFlags',true);
  cudaMalloc3D:=getProc(hh,'cudaMalloc3D',true);
  cudaMalloc3DArray:=getProc(hh,'cudaMalloc3DArray',true);
  cudaMallocMipmappedArray:=getProc(hh,'cudaMallocMipmappedArray',true);
  cudaGetMipmappedArrayLevel:=getProc(hh,'cudaGetMipmappedArrayLevel',true);
  cudaMemcpy3D:=getProc(hh,'cudaMemcpy3D',true);
  cudaMemcpy3DPeer:=getProc(hh,'cudaMemcpy3DPeer',true);
  cudaMemcpy3DAsync:=getProc(hh,'cudaMemcpy3DAsync',true);
  cudaMemcpy3DPeerAsync:=getProc(hh,'cudaMemcpy3DPeerAsync',true);
  cudaMemGetInfo:=getProc(hh,'cudaMemGetInfo',true);
  cudaArrayGetInfo:=getProc(hh,'cudaArrayGetInfo',true);
  cudaMemcpy:=getProc(hh,'cudaMemcpy',true);
  cudaMemcpyPeer:=getProc(hh,'cudaMemcpyPeer',true);
  cudaMemcpyToArray:=getProc(hh,'cudaMemcpyToArray',true);
  cudaMemcpyFromArray:=getProc(hh,'cudaMemcpyFromArray',true);
  cudaMemcpyArrayToArray:=getProc(hh,'cudaMemcpyArrayToArray',true);
  cudaMemcpy2D:=getProc(hh,'cudaMemcpy2D',true);
  cudaMemcpy2DToArray:=getProc(hh,'cudaMemcpy2DToArray',true);
  cudaMemcpy2DFromArray:=getProc(hh,'cudaMemcpy2DFromArray',true);
  cudaMemcpy2DArrayToArray:=getProc(hh,'cudaMemcpy2DArrayToArray',true);
  cudaMemcpyToSymbol:=getProc(hh,'cudaMemcpyToSymbol',true);
  cudaMemcpyFromSymbol:=getProc(hh,'cudaMemcpyFromSymbol',true);
  cudaMemcpyAsync:=getProc(hh,'cudaMemcpyAsync',true);
  cudaMemcpyPeerAsync:=getProc(hh,'cudaMemcpyPeerAsync',true);
  cudaMemcpyToArrayAsync:=getProc(hh,'cudaMemcpyToArrayAsync',true);
  cudaMemcpyFromArrayAsync:=getProc(hh,'cudaMemcpyFromArrayAsync',true);
  cudaMemcpy2DAsync:=getProc(hh,'cudaMemcpy2DAsync',true);
  cudaMemcpy2DToArrayAsync:=getProc(hh,'cudaMemcpy2DToArrayAsync',true);
  cudaMemcpy2DFromArrayAsync:=getProc(hh,'cudaMemcpy2DFromArrayAsync',true);
  cudaMemcpyToSymbolAsync:=getProc(hh,'cudaMemcpyToSymbolAsync',true);
  cudaMemcpyFromSymbolAsync:=getProc(hh,'cudaMemcpyFromSymbolAsync',true);
  cudaMemset:=getProc(hh,'cudaMemset',true);
  cudaMemset2D:=getProc(hh,'cudaMemset2D',true);
  cudaMemset3D:=getProc(hh,'cudaMemset3D',true);
  cudaMemsetAsync:=getProc(hh,'cudaMemsetAsync',true);
  cudaMemset2DAsync:=getProc(hh,'cudaMemset2DAsync',true);
  cudaMemset3DAsync:=getProc(hh,'cudaMemset3DAsync',true);
  cudaGetSymbolAddress:=getProc(hh,'cudaGetSymbolAddress',true);
  cudaGetSymbolSize:=getProc(hh,'cudaGetSymbolSize',true);
  cudaPointerGetAttributes:=getProc(hh,'cudaPointerGetAttributes',true);
  cudaDeviceCanAccessPeer:=getProc(hh,'cudaDeviceCanAccessPeer',true);
  cudaDeviceEnablePeerAccess:=getProc(hh,'cudaDeviceEnablePeerAccess',true);
  cudaDeviceDisablePeerAccess:=getProc(hh,'cudaDeviceDisablePeerAccess',true);
  cudaGraphicsUnregisterResource:=getProc(hh,'cudaGraphicsUnregisterResource',true);
  cudaGraphicsResourceSetMapFlags:=getProc(hh,'cudaGraphicsResourceSetMapFlags',true);
  cudaGraphicsMapResources:=getProc(hh,'cudaGraphicsMapResources',true);
  cudaGraphicsUnmapResources:=getProc(hh,'cudaGraphicsUnmapResources',true);
  cudaGraphicsResourceGetMappedPointer:=getProc(hh,'cudaGraphicsResourceGetMappedPointer',true);
  cudaGraphicsSubResourceGetMappedArray:=getProc(hh,'cudaGraphicsSubResourceGetMappedArray',true);
  cudaGraphicsResourceGetMappedMipmappedArray:=getProc(hh,'cudaGraphicsResourceGetMappedMipmappedArray',true);
  cudaGetChannelDesc:=getProc(hh,'cudaGetChannelDesc',true);
  // cudaChannelFormatDesc:=getProc(hh,'cudaChannelFormatDesc',true);
  cudaBindTexture:=getProc(hh,'cudaBindTexture',true);
  cudaBindTexture2D:=getProc(hh,'cudaBindTexture2D',true);
  cudaBindTextureToArray:=getProc(hh,'cudaBindTextureToArray',true);
  cudaBindTextureToMipmappedArray:=getProc(hh,'cudaBindTextureToMipmappedArray',true);
  cudaUnbindTexture:=getProc(hh,'cudaUnbindTexture',true);
  cudaGetTextureAlignmentOffset:=getProc(hh,'cudaGetTextureAlignmentOffset',true);
  cudaGetTextureReference:=getProc(hh,'cudaGetTextureReference',true);
  cudaBindSurfaceToArray:=getProc(hh,'cudaBindSurfaceToArray',true);
  cudaGetSurfaceReference:=getProc(hh,'cudaGetSurfaceReference',true);
  cudaCreateTextureObject:=getProc(hh,'cudaCreateTextureObject',true);
  cudaDestroyTextureObject:=getProc(hh,'cudaDestroyTextureObject',true);
  cudaGetTextureObjectResourceDesc:=getProc(hh,'cudaGetTextureObjectResourceDesc',true);
  cudaGetTextureObjectTextureDesc:=getProc(hh,'cudaGetTextureObjectTextureDesc',true);
  cudaGetTextureObjectResourceViewDesc:=getProc(hh,'cudaGetTextureObjectResourceViewDesc',true);
  cudaCreateSurfaceObject:=getProc(hh,'cudaCreateSurfaceObject',true);
  cudaDestroySurfaceObject:=getProc(hh,'cudaDestroySurfaceObject',true);
  cudaGetSurfaceObjectResourceDesc:=getProc(hh,'cudaGetSurfaceObjectResourceDesc',true);
  cudaDriverGetVersion:=getProc(hh,'cudaDriverGetVersion',true);
  cudaRuntimeGetVersion:=getProc(hh,'cudaRuntimeGetVersion',true);
  cudaGetExportTable:=getProc(hh,'cudaGetExportTable',true);
end;


function InitCudaRT:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=GloadLibrary(AppDir+'Cuda\'+DLLname1);

  result:=(hh<>0);
  if not result then exit;

  InitCudaRT1;
end;

end.

