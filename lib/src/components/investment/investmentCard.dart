import 'package:flutter/material.dart';

import '../../store/models/ivestment_models.dart';

// --- Data Model ---
// This class defines the structure of the data that the widget will receive.

// --- The Widget ---
class InvestmentCard extends StatelessWidget {
  // The widget receives the data as a parameter in its constructor.
  final InvestmentCardData data;

  const InvestmentCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // The outer container for the entire card
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.title, // Use data from the model
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1F7E3), // Light green background
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  data.status, // Use data from the model
                  style: const TextStyle(
                    color: Color(0xFF00A86B), // Dark green text
                    fontWeight: FontWeight.w600,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Column (Amount & Maturity Date Label)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Title and Status Badge
                  const SizedBox(height: 16.0),
                  _buildLabel("Amount"),
                  const SizedBox(height: 4.0),
                  _buildValue(data.amount), // Use data from the model
                  const SizedBox(height: 16.0),
                  _buildLabel("Maturity Date"),
                ],
              ),
              // Right Column (Interest & Maturity Date Value)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildLabel("Interest"),
                  const SizedBox(height: 4.0),
                  _buildValue(data.interest), // Use data from the model
                  const SizedBox(height: 16.0),
                  _buildValue(data.maturityDate), // Use data from the model
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper function for labels
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
    );
  }

  // Helper function for values
  Widget _buildValue(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
        color: Colors.black87,
      ),
    );
  }
}
