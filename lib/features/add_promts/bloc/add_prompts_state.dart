part of 'add_prompts_bloc.dart';

enum UploadStatus {
  uploading, uploaded, failed,resourceAdded,
}

class AddPromptsInitial {
  final UploadStatus ?uploadStatus;
  final String? side1selectedMediaType;
  final String? side2selectedMediaType;
  final String? side1ResourceUrl;
  final String? side2ResourceUrl;
  final String? side1Id;
  final String? side2Id;
  final bool ? showResource;

  AddPromptsInitial({
    this.showResource,
    this.uploadStatus,
    this.side1selectedMediaType="Text",
    this.side2selectedMediaType="Text",
    this.side1ResourceUrl='',
    this.side2ResourceUrl='',
    this.side1Id='',
    this.side2Id='',
  });

  // CopyWith method
  AddPromptsInitial copyWith({
    bool ? showResource,

    UploadStatus ?uploadStatus,
    String? side1selectedMediaType,
    String? side2selectedMediaType,
    String? side1ResourceUrl,
    String? side2ResourceUrl,
     String? side1Id,
     String? side2Id,

  }) {
    return AddPromptsInitial(
      showResource: showResource??this.showResource,
      uploadStatus: uploadStatus??this.uploadStatus,
      side1Id: side1Id??this.side1Id,
      side2Id: side2Id??this.side2Id,
      side1selectedMediaType: side1selectedMediaType ?? this.side1selectedMediaType,
      side2selectedMediaType: side2selectedMediaType ?? this.side2selectedMediaType,
      side1ResourceUrl: side1ResourceUrl ?? this.side1ResourceUrl,
      side2ResourceUrl: side2ResourceUrl ?? this.side2ResourceUrl,
    );
  }
}


