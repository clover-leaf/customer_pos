import 'package:client_repository/client_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pos/gen/colors.gen.dart';
import 'package:pos/order/order.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final invoiceView =
        context.select((OrderBloc bloc) => bloc.state.invoiceView);
    final showedInvoiceView =
        context.select((OrderBloc bloc) => bloc.state.showedInvoiceView);
    final showedInvoiceIdList = showedInvoiceView.keys.toList();

    if (showedInvoiceView.isEmpty) {
      return const Center(
        child: Text(
          'Your list is empty',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: ColorName.text100,
          ),
        ),
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(0, 24, 24, 24),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: showedInvoiceIdList.length,
              itemBuilder: (context, index) {
                final invoiceId = showedInvoiceIdList[index];
                final invoice = invoiceView[invoiceId]!;
                final invoiceDishes = showedInvoiceView[invoiceId]!;
                return InvoiceCard(
                  invoice: invoice,
                  invoiceDishes: invoiceDishes,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({
    super.key,
    required this.invoice,
    required this.invoiceDishes,
  });

  final Invoice invoice;
  final Iterable<InvoiceDish> invoiceDishes;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('dd MMM yyyy hh:mm:ss').format(invoice.time);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          color: ColorName.blue600,
          width: 1.2,
        ),
        // color: ColorName.blue100,
        // gradient: LinearGradient(
        //   colors: [
        //     ColorName.blue200,
        //     Colors.white,
        //   ],
        // ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ORDER #${invoice.id.split("-").last}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: ColorName.text200,
                ),
              ),
              Text(
                'Placed on $time',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: ColorName.text100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: invoiceDishes.map(InvoiceDishCard.new).toList(),
          )
        ],
      ),
    );
  }
}
