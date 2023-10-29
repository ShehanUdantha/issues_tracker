class IssueModel {
  final String issueId;
  final String ownerId;
  final String profileImage;
  final postedDate;
  final String title;
  final String description;
  final String priority;
  final String status;

  IssueModel({
    required this.issueId,
    required this.ownerId,
    required this.profileImage,
    required this.postedDate,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'issueId': issueId,
        'ownerId': ownerId,
        'profileImage': profileImage,
        'postedDate': postedDate,
        'title': title,
        'description': description,
        'priority': priority,
        'status': status,
      };

  static IssueModel getValueFromSnapshot(var snapshot) {
    return IssueModel(
      issueId: snapshot['issueId'],
      ownerId: snapshot['ownerId'],
      profileImage: snapshot['profileImage'],
      postedDate: snapshot['postedDate'],
      title: snapshot['title'],
      description: snapshot['description'],
      priority: snapshot['priority'],
      status: snapshot['status'],
    );
  }
}
