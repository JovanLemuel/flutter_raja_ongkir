part of 'widgets.dart';

class CardCosts extends StatefulWidget {
  final Costs costs;
  const CardCosts(this.costs);

  @override
  State<CardCosts> createState() => _CardCostsState();
}

class _CardCostsState extends State<CardCosts> {
  @override
  Widget build(BuildContext context) {
    Costs c = widget.costs;
    return Card(
      color: const Color(0xFFFFFFFF),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          // ganti test image
          child: Image.asset("assets/images/test.png"),
        ),
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        title: Text(
          "${c.description} (${c.service})",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i in c.cost ?? []) Text("Biaya: Rp. ${i.value}"),
            for (var i in c.cost ?? [])
              Text(
                "Estimasi Sampai: ${i.etd} HARI",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
