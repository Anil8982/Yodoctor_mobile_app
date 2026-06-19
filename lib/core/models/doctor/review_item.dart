class ReviewItem {
  final String id;
  final String patientName;
  final double rating;
  final String comment;
  final DateTime date;

  const ReviewItem({
    required this.id,
    required this.patientName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}