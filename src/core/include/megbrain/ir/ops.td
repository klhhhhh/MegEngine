#ifndef MGB_OPS
#define MGB_OPS

include "base.td"
include "param_defs.td"

include "mlir/Interfaces/SideEffectInterfaces.td"

def Elemwise : MgbHashableOp<"Elemwise", [ElemwiseParam], [NoSideEffect]> {
  let inputs = (ins Variadic<AnyType>:$input);
  let results = (outs AnyType);
  let nameFunction = [{
    return to_string($_self.mode);
  }];
}

def Reduce: MgbHashableOp<"Reduce", [ReduceParam]>{
  let extraArguments = (ins
    MgbDefaultValuedAttr<MgbBoolAttr, "true">:$keepdim
  );
}

def TypeCvt: MgbHashableOp<"TypeCvt", [], [NoSideEffect]> {
  let inputs = (ins AnyType:$inputs);
  let extraArguments = (ins
    TypeAttr:$idtype,
    MgbDTypeAttr:$dtype
  );
  let results = (outs AnyType);
}

def MatrixInverse: MgbHashableOp<"MatrixInverse", [EmptyParam]>;

def MatrixMul: MgbHashableOp<"MatrixMul", [MatrixMulParam, ExecutionPolicyParamBase<"policy">]> {
  let extraArguments = (ins
    MgbUI32Attr:$dimA,
    MgbUI32Attr:$dimB
  );
}

def BatchedMatrixMul: MgbHashableOp<"BatchedMatmul", [MatrixMulParam, ExecutionPolicyParamBase<"policy">]> {
  let extraArguments = (ins
    MgbUI32Attr:$dimA,
    MgbUI32Attr:$dimB
  );
}

def Dot: MgbHashableOp<"Dot", [EmptyParam]>;

def SVD: MgbHashableOp<"SVD", [SVDParam]>;

def Convolution : MgbHashableOp<"Convolution", [ConvolutionParam, ExecutionPolicyParamBase<"policy">]>;

def ConvolutionBackwardData: MgbHashableOp<"ConvolutionBackwardData", [ConvolutionParam, ExecutionPolicyParamBase<"policy">]> {
  let extraArguments = (ins
    MgbDTypeAttr:$dtype
  );
}

def Convolution3D: MgbHashableOp<"Convolution3D", [Convolution3DParam, ExecutionPolicyParamBase<"policy">]>;

def Convolution3DBackwardData: MgbHashableOp<"Convolution3DBackwardData", [Convolution3DParam, ExecutionPolicyParamBase<"policy">]>;

def DeformableConv : MgbHashableOp<"DeformableConv", [ConvolutionParam, ExecutionPolicyParamBase<"policy">]>;

def GroupLocal: MgbHashableOp<"GroupLocal", [ConvolutionParam]>;

def Pooling: MgbHashableOp<"Pooling", [PoolingParam, ExecutionPolicyParamBase<"policy">]>;

def AdaptivePooling : MgbHashableOp<"AdaptivePooling", [AdaptivePoolingParam]> {
  let extraArguments = (ins
    MgbArrayAttr<MgbI32Attr>:$shape
  );
}

def ROIPooling: MgbHashableOp<"ROIPooling", [ROIPoolingParam]>;

def DeformablePSROIPooling : MgbHashableOp<"DeformablePSROIPooling", [DeformablePSROIPoolingParam]>;

def ConvBias : MgbHashableOp<"ConvBias", [ConvBiasParam, ExecutionPolicyParamBase<"policy">]> {
  let extraArguments = (ins
    MgbDTypeAttr:$dtype
  );
}

def BatchConvBias : MgbHashableOp<"BatchConvBias", [BatchConvBiasParam, ExecutionPolicyParamBase<"policy">]> {
  let extraArguments = (ins
    MgbDTypeAttr:$dtype
  );
}

def Images2Neibs : MgbHashableOp<"Images2Neibs", [Images2NeibsParam]>;

def SlidingWindowTranspose : MgbHashableOp<"SlidingWindowTranspose", [SlidingWindowTransposeParam]>;

def BatchNorm : MgbHashableOp<"BatchNorm", [BNParam]>;

def BatchNormBackward : MgbHashableOp<"BatchNormBackward", [BNParam]>;

def ROIAlign: MgbHashableOp<"ROIAlign", [ROIAlignParam]>;
def Correlation: MgbHashableOp<"Correlation", [CorrelationParam]>;

def WarpPerspective: MgbHashableOp<"WarpPerspective", [WarpPerspectiveParam]>;

def WarpAffine: MgbHashableOp<"WarpAffine", [WarpAffineParam]>;

def WarpPerspectiveBackwardData: MgbHashableOp<"WarpPerspectiveBackwardData", [WarpPerspectiveParam]>;

def WarpPerspectiveBackwardMat: MgbHashableOp<"WarpPerspectiveBackwardMat", [WarpPerspectiveParam]>;

def Remap: MgbHashableOp<"Remap", [RemapParam]>;

def Resize: MgbHashableOp<"Resize", [ResizeParam]>;

def Resize3D: MgbHashableOp<"Resize3D", [Resize3DParam]>;

def IndexingOneHot: MgbHashableOp<"IndexingOneHot", [AxisParam]> {
  let extraArguments = (ins
    MgbI32Attr:$ndim
  );
}

def IndexingSetOneHot: MgbHashableOp<"IndexingSetOneHot", [AxisParam]> {
  let extraArguments = (ins
    MgbI32Attr:$ndim
  );
}

def Copy: MgbHashableOp<"Copy"> {
  let extraArguments = (ins
    MgbCompNodeAttr:$comp_node
  );
}

def Borrow: MgbHashableOp<"Borrow"> {
  let extraArguments = (ins
    MgbCompNodeAttr:$comp_node
  );
}

def Barrier: MgbHashableOp<"Barrier"> {
  let extraArguments = (ins
    MgbCompNodeAttr:$comp_node,
    MgbUI32Attr:$nr_outputs
  );
}

def Argsort: MgbHashableOp<"Argsort", [ArgsortParam]>;

def Argmax : MgbHashableOp<"Argmax", [AxisParam]>;

def Argmin : MgbHashableOp<"Argmin", [AxisParam]>;

def CondTake : MgbHashableOp<"CondTake">;

def TopK: MgbHashableOp<"TopK", [TopKParam]>;

def NvOf: MgbHashableOp<"NvOf", [NvOfParam]>;

def UniformRNG: MgbHashableOp<"UniformRNG", [UniformRNGParam]> {
  let extraArguments = (ins
    MgbSizeTAddr:$handle
  );
  let hashFunction = [{
    return mgb::hash_pair_combine(
      mgb::hash($_self.dyn_typeinfo()),
      mgb::hash_pair_combine(
        mgb::hash($_self.handle),
        mgb::hash($_self.dtype.enumv())
      )
    );
  }];
  let cmpFunction = [{return $0.handle == $1.handle && $0.dtype == $1.dtype;}];
}

def GaussianRNG: MgbHashableOp<"GaussianRNG", [GaussianRNGParam]> {
  let extraArguments = (ins
    MgbSizeTAddr:$handle
  );
  let hashFunction = [{
    return mgb::hash_pair_combine(
      mgb::hash($_self.dyn_typeinfo()),
      mgb::hash_pair_combine(
        mgb::hash($_self.handle),
        mgb::hash_pair_combine(
          mgb::hash($_self.mean),
          mgb::hash_pair_combine(
            mgb::hash($_self.std),
            mgb::hash($_self.dtype.enumv())
          )
        )
      )
    );
  }];
  let cmpFunction = [{return $0.handle == $1.handle && $0.mean == $1.mean && $0.std == $1.std && $0.dtype == $1.dtype;}];
}

def GammaRNG: MgbHashableOp<"GammaRNG", [GammaRNGParam]> {
  let extraArguments = (ins
    MgbSizeTAddr:$handle
  );
  let hashFunction = [{
    return mgb::hash_pair_combine(
      mgb::hash($_self.dyn_typeinfo()),
      mgb::hash($_self.handle)
      );
  }];
  let cmpFunction = [{return $0.handle == $1.handle;}];
}

def PoissonRNG: MgbHashableOp<"PoissonRNG", [PoissonRNGParam]> {
  let extraArguments = (ins
    MgbSizeTAddr:$handle
  );
  let hashFunction = [{
    return mgb::hash_pair_combine(
      mgb::hash($_self.dyn_typeinfo()),
      mgb::hash($_self.handle)
      );
  }];
  let cmpFunction = [{return $0.handle == $1.handle;}];
}

def BetaRNG: MgbHashableOp<"BetaRNG", [BetaRNGParam]> {
  let extraArguments = (ins
    MgbSizeTAddr:$handle
  );
  let hashFunction = [{
    return mgb::hash_pair_combine(
      mgb::hash($_self.dyn_typeinfo()),
      mgb::hash($_self.handle)
      );
  }];
  let cmpFunction = [{return $0.handle == $1.handle;}];
}

def PermutationRNG: MgbHashableOp<"PermutationRNG", [PermutationRNGParam]> {
  let extraArguments = (ins
    MgbSizeTAddr:$handle
  );
  let hashFunction = [{
    return mgb::hash_pair_combine(
      mgb::hash($_self.dyn_typeinfo()),
      mgb::hash_pair_combine(
        mgb::hash($_self.handle),
        mgb::hash($_self.dtype.enumv())
      )
    );
  }];
  let cmpFunction = [{return $0.handle == $1.handle && $0.dtype == $1.dtype;}];
}

def Fill: MgbHashableOp<"Fill", [FillParam]> {
  let extraArguments = (ins
    MgbDTypeAttr:$dtype,
    MgbCompNodeAttr:$comp_node
  );
}

def FillLike: MgbHashableOp<"FillLike", [FillParam]> {
  let extraArguments = (ins
    MgbCompNodeAttr:$comp_node
  );
}

def ShuffleRNG: MgbHashableOp<"ShuffleRNG", [ShuffleRNGParam]> {
  let extraArguments = (ins
    MgbSizeTAddr:$handle
  );
  let hashFunction = [{
    return mgb::hash_pair_combine(
      mgb::hash($_self.dyn_typeinfo()),
      mgb::hash($_self.handle)
      );
  }];
  let cmpFunction = [{return $0.handle == $1.handle;}];
}

def Linspace: MgbHashableOp<"Linspace", [LinspaceParam]> {
  let extraArguments = (ins
    MgbCompNodeAttr:$comp_node
  );
}

def Eye: MgbHashableOp<"Eye", [EyeParam]> {
  let extraArguments = (ins
    MgbCompNodeAttr:$comp_node
  );
}

def Diag: MgbHashableOp<"Diag", [DiagParam]>;

def GetVarShape : MgbHashableOp<"GetVarShape", [OptionalAxisV1Param]>;

def Concat: MgbHashableOp<"Concat", [AxisParam]> {
  let extraArguments = (ins
    MgbCompNodeAttr:$comp_node
  );
}

def Stack: MgbHashableOp<"Stack", [AxisParam]> {
  let extraArguments = (ins
    MgbCompNodeAttr:$comp_node
  );
}

def Broadcast : MgbHashableOp<"Broadcast", [EmptyParam]> {
  let extraArguments = (ins
    MgbArrayAttr<MgbI32Attr>:$shape
  );
}

def Identity: MgbHashableOp<"Identity">;

def CollectiveComm : MgbHashableOp<"CollectiveComm", [CollectiveCommParam]> {
  let extraArguments = (ins
    MgbStringAttr:$key,
    MgbUI32Attr:$nr_devices,
    MgbUI32Attr:$rank,
    MgbBoolAttr:$is_root,
    MgbBoolAttr:$local_grad,
    MgbStringAttr:$addr,
    MgbUI32Attr:$port,
    MgbDTypeAttr:$dtype,
    MgbStringAttr:$backend,
    MgbStringAttr:$comp_node
  );
}

def RemoteSend : MgbHashableOp<"RemoteSend"> {
  let extraArguments = (ins
    MgbStringAttr:$key,
    MgbStringAttr:$addr,
    MgbUI32Attr:$port,
    MgbUI32Attr:$rank_to,
    MgbStringAttr:$backend
  );
}

def RemoteRecv : MgbHashableOp<"RemoteRecv"> {
  let extraArguments = (ins
    MgbStringAttr:$key,
    MgbStringAttr:$addr,
    MgbUI32Attr:$port,
    MgbUI32Attr:$rank_from,
    MgbCompNodeAttr:$cn,
    MgbArrayAttr<MgbI32Attr>:$shape,
    MgbDTypeAttr:$dtype,
    MgbStringAttr:$backend
  );
}

def NMSKeep : MgbHashableOp<"NMSKeep"> {
  let extraArguments = (ins
    MgbF32Attr:$iou_thresh,
    MgbUI32Attr:$max_output
  );
}

def ParamPackSplit : MgbHashableOp<"ParamPackSplit"> {
  let extraArguments = (ins
    MgbArrayAttr<MgbI32Attr>:$offsets,
    MgbArrayAttr<MgbArrayAttr<MgbSizeTAddr>>:$shapes
  );
}

def ParamPackConcat : MgbHashableOp<"ParamPackConcat"> {
  let extraArguments = (ins
    MgbArrayAttr<MgbI32Attr>:$offsets
  );
}

def Dimshuffle: MgbHashableOp<"Dimshuffle"> {
  let inputs = (ins AnyMemRef:$input);
  let extraArguments = (ins MgbArrayAttr<MgbI32Attr>:$pattern);
  let results = (outs AnyMemRef);
}

def Reshape: MgbHashableOp<"Reshape", [OptionalAxisV1Param]> {
  let extraArguments = (ins
    MgbArrayAttr<MgbI32Attr>:$shape
  );
}

// TODO: merge Add/Remove Axis into AxisAddRemove as megbrain?
def AddAxis: MgbHashableOp<"AddAxis"> {
  let extraArguments = (ins
    MgbArrayAttr<MgbI32Attr>:$axis
  );
}
def RemoveAxis: MgbHashableOp<"RemoveAxis"> {
  let extraArguments = (ins
    MgbArrayAttr<MgbI32Attr>:$axis
  );
}

class FancyIndexingBase<string name>: MgbHashableOp<name> {
  let extraArguments = (ins
    MgbArrayAttr<MgbTupleAttr<
      [MgbI8Attr, MgbBoolAttr, MgbBoolAttr, MgbBoolAttr, MgbBoolAttr]>>:$items
  );
}

def Subtensor: MgbHashableOp<"Subtensor"> {
  let extraArguments = (ins
    MgbArrayAttr<MgbTupleAttr<
      [MgbI8Attr, MgbBoolAttr, MgbBoolAttr, MgbBoolAttr, MgbBoolAttr]>>:$items,
    MgbArrayAttr<MgbTupleAttr<[MgbI32Attr, MgbI32Attr, MgbI32Attr, MgbI32Attr]>>:$slice_items
  );
}

// def Subtensor: FancyIndexingBase<"Subtensor">;
def SetSubtensor: FancyIndexingBase<"SetSubtensor">;
def IncrSubtensor: FancyIndexingBase<"IncrSubtensor">;
def IndexingMultiAxisVec: FancyIndexingBase<"IndexingMultiAxisVec">;
def IndexingSetMultiAxisVec: FancyIndexingBase<"IndexingSetMultiAxisVec">;
def IndexingIncrMultiAxisVec: FancyIndexingBase<"IndexingIncrMultiAxisVec">;
def MeshIndexing: FancyIndexingBase<"MeshIndexing">;
def IncrMeshIndexing: FancyIndexingBase<"IncrMeshIndexing">;
def SetMeshIndexing: FancyIndexingBase<"SetMeshIndexing">;
def BatchedMeshIndexing: FancyIndexingBase<"BatchedMeshIndexing">;
def BatchedIncrMeshIndexing: FancyIndexingBase<"BatchedIncrMeshIndexing">;
def BatchedSetMeshIndexing: FancyIndexingBase<"BatchedSetMeshIndexing">;

def FakeQuant: MgbHashableOp<"FakeQuant", [FakeQuantParam]>;
def AssertEqual: MgbHashableOp<"AssertEqual",[AssertEqualParam]>;
def TQT: MgbHashableOp<"TQT", [TQTParam]>;
def LSQ: MgbHashableOp<"LSQ", [LSQParam]>;
def Softmax: MgbHashableOp<"Softmax", [SoftmaxParam]>;
def ElemwiseMultiType: MgbHashableOp<"ElemwiseMultiType", [ElemwiseMultiTypeParam]> {
  let extraArguments = (ins
    MgbDTypeAttr:$dtype
  );
  let nameFunction = [{
    return to_string($_self.mode);
  }];
}

def InplaceAdd: MgbHashableOp<"InplaceAdd", [EmptyParam]>;

def TensorRTRuntime: MgbHashableOp<"TensorRTRuntime"> {
  let extraArguments = (ins
    MgbStringAttr:$buf,
    MgbSizeTAddr:$buf_size
  );
}

def AtlasRuntime: MgbHashableOp<"AtlasRuntime"> {
  let extraArguments = (ins
    MgbStringAttr:$buf,
    MgbSizeTAddr:$buf_size
  );
}

def CambriconRuntime: MgbHashableOp<"CambriconRuntime"> {
  let extraArguments = (ins
    MgbStringAttr:$buf,
    MgbSizeTAddr:$buf_size,
    MgbStringAttr:$symbol,
    MgbBoolAttr:$tensor_dim_mutable
  );
}

def MagicMindRuntime: MgbHashableOp<"MagicMindRuntime"> {
  let extraArguments = (ins
    MgbStringAttr:$buf,
    MgbSizeTAddr:$buf_size
  );
}

def CvtColor: MgbHashableOp<"CvtColor", [CvtColorParam]>;

def CheckNonFinite: MgbHashableOp<"CheckNonFinite", [CheckNonFiniteParam]>;

def FastpathCopy: MgbHashableOp<"FastpathCopy">;

def PixelShuffle: MgbHashableOp<"PixelShuffle"> {
  let extraArguments = (ins
    MgbI32Attr:$factor
  );
}

def PixelShuffleBackward: MgbHashableOp<"PixelShuffleBackward"> {
  let extraArguments = (ins
    MgbI32Attr:$factor
  );
}

def ExternOpr: MgbHashableOp<"ExternOpr"> {
  let extraArguments = (ins
    MgbArrayAttr<MgbArrayAttr<MgbSizeTAddr>>:$output_shapes,
    MgbStringAttr:$name,
    MgbStringAttr:$data,
    MgbSizeTAddr:$data_len,
    MgbArrayAttr<MgbDTypeAttr>:$output_dtypes
  );
  let hashFunction = [{
    return mgb::hash_pair_combine(
      mgb::hash($_self.dyn_typeinfo()),
      mgb::hash_pair_combine(
        mgb::hash($_self.name),
        mgb::hash($_self.data))
      );
  }];
}

def Cumsum: MgbHashableOp<"Cumsum", [CumsumParam]>;

def Split: MgbHashableOp<"Split", [EmptyParam]> {
  let extraArguments = (ins
    MgbI32Attr:$axis,
    MgbI32Attr:$nsections
  );
}

def Padding: MgbHashableOp<"Padding", [PaddingParam]>;

def LRN: MgbHashableOp<"LRN", [LRNParam]>;

def LayerNorm: MgbHashableOp<"LayerNorm", [LayerNormParam]>;

def GroupNorm: MgbHashableOp<"GroupNorm", [GroupNormParam]>;

def GeneralNorm: MgbHashableOp<"GeneralNorm", [GeneralNormParam]>;

def LAMBUpdate: MgbHashableOp<"LAMBUpdate", [LAMBUpdateParam]>;

def RNNCell: MgbHashableOp<"RNNCell", [RNNCellParam]>;

def LSTMCell: MgbHashableOp<"LSTMCell", [EmptyParam]>;

def InstanceNorm: MgbHashableOp<"InstanceNorm",[GroupNormParam]>;

def RNN: MgbHashableOp<"RNN", [RNNParam]>;

def LSTM: MgbHashableOp<"LSTM", [LSTMParam]>;

def Dropout: MgbHashableOp<"Dropout", [DropoutParam]> {
  let extraArguments = (ins
    MgbSizeTAddr:$handle
  );
  let hashFunction = [{
    return mgb::hash_pair_combine(
      mgb::hash($_self.dyn_typeinfo()),
      mgb::hash_pair_combine(
        mgb::hash($_self.drop_prob),
        mgb::hash($_self.handle))
      );
  }];
  let cmpFunction = [{return $0.handle == $1.handle && $0.drop_prob == $1.drop_prob;}];
}
def MeshGrid: MgbHashableOp<"MeshGrid"> {
  let extraArguments = (ins
  MgbStringAttr:$indexing
  );
}

def RegionRestrictedConvolution: MgbHashableOp<"RegionRestrictedConvolution", [ConvolutionParam]>;

def RegionRestrictedConvolutionBackwardData: MgbHashableOp<"RegionRestrictedConvolutionBackwardData", [ConvolutionParam]>;
def MaskedFill: MgbHashableOp<"MaskedFill", [FillParam]>;
def MultiHeadAttn: MgbHashableOp<"MultiHeadAttn", [MultiHeadAttnParam]> {
  let extraArguments = (ins
    MgbSizeTAddr:$handle
  );
  let hashFunction = [{
    return mgb::hash_pair_combine(
      mgb::hash($_self.dyn_typeinfo()),
      mgb::hash_pair_combine(
        mgb::hash($_self.handle),
        mgb::hash_pair_combine(
          mgb::hash($_self.num_heads),
          mgb::hash_pair_combine(
            mgb::hash($_self.embeding_size),
            mgb::hash_pair_combine(
              mgb::hash($_self.k_size),
              mgb::hash_pair_combine(
                mgb::hash($_self.v_size),
                mgb::hash_pair_combine(
                  mgb::hash($_self.qproj_size),
                  mgb::hash_pair_combine(
                    mgb::hash($_self.kproj_size),
                    mgb::hash_pair_combine(
                      mgb::hash($_self.vproj_size),
                      mgb::hash_pair_combine(
                        mgb::hash($_self.oproj_size),
                        mgb::hash_pair_combine(
                          mgb::hash($_self.qbias),
                          mgb::hash_pair_combine(
                            mgb::hash($_self.kbias),
                            mgb::hash_pair_combine(
                              mgb::hash($_self.vbias),
                              mgb::hash_pair_combine(
                                mgb::hash($_self.obias),
                                mgb::hash_pair_combine(
                                  mgb::hash($_self.sm_scaler),
                                  mgb::hash_pair_combine(
                                    mgb::hash($_self.input_order),
                                    mgb::hash_pair_combine(
                                      mgb::hash($_self.attn_mask_type),
                                      mgb::hash_pair_combine(
                                        mgb::hash($_self.tensor_combination_type),
                                        mgb::hash_pair_combine(
                                          mgb::hash($_self.add_zero_attn),
                                          mgb::hash_pair_combine(
                                            mgb::hash($_self.need_weights),
                                            mgb::hash_pair_combine(
                                              mgb::hash($_self.reslink),
                                              mgb::hash_pair_combine(
                                                mgb::hash($_self.training),
                                                mgb::hash_pair_combine(
                                                  mgb::hash($_self.attn_prob),
                                                  mgb::hash($_self.out_prob))
                                                )
                                              )
                                            )
                                          )
                                        )
                                      )
                                    )
                                  )
                                )
                              )
                            )
                          )
                        )
                      )
                    )
                  )
                )
              )
            )
          )
        )
      );
  }];
  let cmpFunction = [{return $0.handle == $1.handle && $0.num_heads == $1.num_heads && $0.embeding_size == $1.embeding_size && $0.k_size == $1.k_size && $0.v_size == $1.v_size && $0.qproj_size == $1.qproj_size && $0.kproj_size == $1.kproj_size && $0.vproj_size == $1.vproj_size && $0.oproj_size == $1.oproj_size && $0.qbias == $1.qbias && $0.kbias == $1.kbias && $0.vbias == $1.vbias && $0.obias == $1.obias && $0.sm_scaler == $1.sm_scaler && $0.input_order == $1.input_order && $0.reslink == $1.reslink && $0.training == $1.training && $0.need_weights == $1.need_weights && $0.attn_mask_type == $1.attn_mask_type && $0.add_zero_attn == $1.add_zero_attn && $0.tensor_combination_type == $1.tensor_combination_type && $0.attn_prob == $1.attn_prob && $0.out_prob == $1.out_prob;}];

}


def Cross: MgbHashableOp<"Cross", [CrossParam]>;
#endif // MGB_OPS
