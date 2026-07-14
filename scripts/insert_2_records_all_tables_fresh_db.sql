-- =====================================================================
-- Insert 2 sample records into EVERY table — for a FRESH/EMPTY database.
-- Creates its own business + branch first, then uses their IDs everywhere.
-- Run this on an empty msms-schema database (tables exist, 0 rows).
-- =====================================================================

-- 0. BUSINESS + BRANCH (created first, IDs captured into session variables)
INSERT INTO businesses (
    name, legal_name, short_name, email, phone, city, state, country,
    gstin, drug_license_no, is_gst_registered, setup_complete, created_at, updated_at
) VALUES (
    'Demo Pharmacy', 'Demo Pharmacy Pvt Ltd', 'DemoPharma', 'business@example.com', '9000000000',
    'Mumbai', 'Maharashtra', 'India', '27ABCDE1111F1Z5', 'DL-BIZ-DEMO-01', 1, 1, NOW(), NOW()
);
SET @business_id = LAST_INSERT_ID();

INSERT INTO branches (
    business_id, name, code, is_headquarters, is_active, phone, email,
    city, state, drug_license_no, created_at, updated_at
) VALUES (
    @business_id, 'Demo Main Branch', 'BR-DEMO-01', 1, 1, '9000000001', 'branch1@example.com',
    'Mumbai', 'Maharashtra', 'DL-BR-DEMO-01', NOW(), NOW()
);
SET @branch_id = LAST_INSERT_ID();

-- 1. USERS (2 records — includes a new admin user)
INSERT INTO users (
    branch_id, username, email, full_name, phone,
    password_hash, role, is_active, is_verified,
    designation, qualification, theme, language,
    created_at, updated_at
) VALUES
(@branch_id, 'admin_demo1', 'admin_demo1@example.com', 'Demo Admin One', '9000000001',
 '$2b$12$Q7NPAz42gc.ei95bwnZVoOqCqjWdrJD0FlsnZua21T24npYH0gzXi', 'admin', 1, 1,
 'Administrator', 'MCA', 'light', 'en', NOW(), NOW()),
(@branch_id, 'pharmacist_demo1', 'pharmacist_demo1@example.com', 'Demo Pharmacist One', '9000000002',
 '$2b$12$Q7NPAz42gc.ei95bwnZVoOqCqjWdrJD0FlsnZua21T24npYH0gzXi', 'pharmacist', 1, 1,
 'Pharmacist', 'B.Pharm', 'light', 'en', NOW(), NOW());

-- 2. MEDICINE CATEGORIES (2 records)
INSERT INTO medicine_categories (business_id, name, created_at) VALUES
(@business_id, 'Demo Category A', NOW()),
(@business_id, 'Demo Category B', NOW());

-- 3. SUPPLIERS (2 records)
INSERT INTO suppliers (
    business_id, supplier_code, name, contact_person, phone, email,
    gst_number, drug_license_no, address, city, state,
    payment_terms, credit_limit, outstanding, performance_score,
    is_active, is_deleted, created_at, updated_at
) VALUES
(@business_id, 'SUP-DEMO-01', 'Demo Supplier One', 'Ramesh Kumar', '9111000001', 'supplier1@example.com',
 '27ABCDE1234F1Z5', 'DL-DEMO-001', 'Demo Address 1', 'Mumbai', 'Maharashtra',
 30, 100000.00, 0.00, 5.0, 1, 0, NOW(), NOW()),
(@business_id, 'SUP-DEMO-02', 'Demo Supplier Two', 'Suresh Patel', '9111000002', 'supplier2@example.com',
 '27ABCDE5678F1Z5', 'DL-DEMO-002', 'Demo Address 2', 'Pune', 'Maharashtra',
 45, 150000.00, 0.00, 5.0, 1, 0, NOW(), NOW());

-- 4. PATIENTS (2 records)
INSERT INTO patients (
    business_id, patient_code, full_name, phone, email, dob, gender, address,
    blood_group, loyalty_points, total_purchases, loyalty_tier, is_active, created_at
) VALUES
(@business_id, 'PAT-DEMO-01', 'Demo Patient One', '9222000001', 'patient1@example.com', '1990-05-15', 'male',
 'Demo Address 1', 'O+', 0, 0, 'silver', 1, NOW()),
(@business_id, 'PAT-DEMO-02', 'Demo Patient Two', '9222000002', 'patient2@example.com', '1985-08-20', 'female',
 'Demo Address 2', 'B+', 0, 0, 'silver', 1, NOW());

-- 5. DOCTORS (2 records)
INSERT INTO doctors (
    business_id, doctor_code, full_name, specialization, qualification,
    registration_no, phone, email, clinic_name, clinic_address, is_active, created_at
) VALUES
(@business_id, 'DOC-DEMO-01', 'Dr. Demo One', 'General Physician', 'MBBS',
 'REG-DEMO-001', '9333000001', 'doctor1@example.com', 'Demo Clinic 1', 'Clinic Address 1', 1, NOW()),
(@business_id, 'DOC-DEMO-02', 'Dr. Demo Two', 'Pediatrician', 'MBBS, MD',
 'REG-DEMO-002', '9333000002', 'doctor2@example.com', 'Demo Clinic 2', 'Clinic Address 2', 1, NOW());

-- 6. MEDICINES (2 records)
INSERT INTO medicines (
    business_id, medicine_code, name, generic_name, brand_name, salt_composition,
    category_id, manufacturer, hsn_code, schedule_type, gst_rate, mrp,
    purchase_rate, selling_rate, unit, pack_size, barcode,
    prescription_req, is_active, is_deleted, created_at, updated_at
) VALUES
(@business_id, 'MED-DEMO-01', 'Demo Paracetamol 500mg', 'Paracetamol', 'Demo Brand P', 'Paracetamol 500mg',
 (SELECT id FROM medicine_categories WHERE name='Demo Category A' AND business_id=@business_id LIMIT 1),
 'Demo Pharma Ltd', '30049099', 'OTC', 12.00, 30.00, 15.00, 25.00, 'Strip', 10,
 'DEMOBAR0001', 0, 1, 0, NOW(), NOW()),
(@business_id, 'MED-DEMO-02', 'Demo Amoxicillin 250mg', 'Amoxicillin', 'Demo Brand A', 'Amoxicillin 250mg',
 (SELECT id FROM medicine_categories WHERE name='Demo Category B' AND business_id=@business_id LIMIT 1),
 'Demo Pharma Ltd', '30041020', 'H', 12.00, 80.00, 45.00, 70.00, 'Strip', 10,
 'DEMOBAR0002', 1, 1, 0, NOW(), NOW());

-- 7. MEDICINE BATCHES (2 records)
INSERT INTO medicine_batches (
    medicine_id, branch_id, batch_number, mfg_date, expiry_date,
    quantity, reserved_qty, purchase_rate, mrp, selling_rate,
    rack_location, is_expired, is_damaged, created_at, updated_at
) VALUES
((SELECT id FROM medicines WHERE medicine_code='MED-DEMO-01' AND business_id=@business_id LIMIT 1), @branch_id, 'BATCH-DEMO-01',
 '2026-01-01', '2027-12-31', 100, 0, 15.00, 30.00, 25.00, 'A1', 0, 0, NOW(), NOW()),
((SELECT id FROM medicines WHERE medicine_code='MED-DEMO-02' AND business_id=@business_id LIMIT 1), @branch_id, 'BATCH-DEMO-02',
 '2026-02-01', '2027-06-30', 50, 0, 45.00, 80.00, 70.00, 'A2', 0, 0, NOW(), NOW());

-- 8. PURCHASE ORDERS (2 records)
INSERT INTO purchase_orders (
    business_id, branch_id, po_number, supplier_id, order_date, expected_date,
    status, total_amount, notes, created_by, created_at
) VALUES
(@business_id, @branch_id, 'PO-DEMO-01', (SELECT id FROM suppliers WHERE supplier_code='SUP-DEMO-01' AND business_id=@business_id LIMIT 1),
 CURDATE(), CURDATE() + INTERVAL 7 DAY, 'draft', 1500.00, 'Demo PO 1',
 (SELECT id FROM users WHERE username='admin_demo1' LIMIT 1), NOW()),
(@business_id, @branch_id, 'PO-DEMO-02', (SELECT id FROM suppliers WHERE supplier_code='SUP-DEMO-02' AND business_id=@business_id LIMIT 1),
 CURDATE(), CURDATE() + INTERVAL 10 DAY, 'sent', 4000.00, 'Demo PO 2',
 (SELECT id FROM users WHERE username='admin_demo1' LIMIT 1), NOW());

-- 9. PURCHASE ORDER ITEMS (2 records)
INSERT INTO purchase_order_items (po_id, medicine_id, quantity, rate) VALUES
((SELECT id FROM purchase_orders WHERE po_number='PO-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM medicines WHERE medicine_code='MED-DEMO-01' AND business_id=@business_id LIMIT 1), 100, 15.00),
((SELECT id FROM purchase_orders WHERE po_number='PO-DEMO-02' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM medicines WHERE medicine_code='MED-DEMO-02' AND business_id=@business_id LIMIT 1), 50, 45.00);

-- 10. PURCHASES (2 records)
INSERT INTO purchases (
    business_id, branch_id, bill_number, po_id, supplier_id, bill_date,
    invoice_number, invoice_date, subtotal, discount_amount, cgst_amount, sgst_amount,
    igst_amount, total_amount, paid_amount, due_amount, payment_mode, payment_status,
    notes, created_by, created_at
) VALUES
(@business_id, @branch_id, 'PUR-DEMO-01', (SELECT id FROM purchase_orders WHERE po_number='PO-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM suppliers WHERE supplier_code='SUP-DEMO-01' AND business_id=@business_id LIMIT 1), CURDATE(),
 'INV-SUP-001', CURDATE(), 1500.00, 0.00, 90.00, 90.00, 0.00, 1680.00, 1680.00, 0.00,
 'bank_transfer', 'paid', 'Demo Purchase 1',
 (SELECT id FROM users WHERE username='admin_demo1' LIMIT 1), NOW()),
(@business_id, @branch_id, 'PUR-DEMO-02', (SELECT id FROM purchase_orders WHERE po_number='PO-DEMO-02' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM suppliers WHERE supplier_code='SUP-DEMO-02' AND business_id=@business_id LIMIT 1), CURDATE(),
 'INV-SUP-002', CURDATE(), 4000.00, 0.00, 240.00, 240.00, 0.00, 4480.00, 2000.00, 2480.00,
 'credit', 'partial', 'Demo Purchase 2',
 (SELECT id FROM users WHERE username='admin_demo1' LIMIT 1), NOW());

-- 11. PURCHASE ITEMS (2 records)
INSERT INTO purchase_items (
    purchase_id, medicine_id, batch_number, mfg_date, expiry_date,
    quantity, free_quantity, purchase_rate, mrp, discount_pct, gst_rate,
    cgst_amount, sgst_amount, igst_amount, total_amount
) VALUES
((SELECT id FROM purchases WHERE bill_number='PUR-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM medicines WHERE medicine_code='MED-DEMO-01' AND business_id=@business_id LIMIT 1),
 'BATCH-DEMO-01', '2026-01-01', '2027-12-31', 100, 0, 15.00, 30.00, 0.00, 12.00,
 90.00, 90.00, 0.00, 1680.00),
((SELECT id FROM purchases WHERE bill_number='PUR-DEMO-02' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM medicines WHERE medicine_code='MED-DEMO-02' AND business_id=@business_id LIMIT 1),
 'BATCH-DEMO-02', '2026-02-01', '2027-06-30', 50, 0, 45.00, 80.00, 0.00, 12.00,
 240.00, 240.00, 0.00, 4480.00);

-- 12. PRESCRIPTIONS (2 records)
INSERT INTO prescriptions (
    business_id, branch_id, prescription_code, patient_id, doctor_id, rx_date,
    is_verified, validity_days, status, notes, created_at
) VALUES
(@business_id, @branch_id, 'RX-DEMO-01', (SELECT id FROM patients WHERE patient_code='PAT-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM doctors WHERE doctor_code='DOC-DEMO-01' AND business_id=@business_id LIMIT 1), CURDATE(), 1, 30,
 'verified', 'Demo Rx 1', NOW()),
(@business_id, @branch_id, 'RX-DEMO-02', (SELECT id FROM patients WHERE patient_code='PAT-DEMO-02' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM doctors WHERE doctor_code='DOC-DEMO-02' AND business_id=@business_id LIMIT 1), CURDATE(), 0, 30,
 'pending', 'Demo Rx 2', NOW());

-- 13. PRESCRIPTION ITEMS (2 records)
INSERT INTO prescription_items (
    prescription_id, medicine_id, generic_name, dosage, duration, instructions, quantity, dispensed_qty
) VALUES
((SELECT id FROM prescriptions WHERE prescription_code='RX-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM medicines WHERE medicine_code='MED-DEMO-01' AND business_id=@business_id LIMIT 1),
 'Paracetamol', '1-0-1', '5 days', 'After food', 10, 10),
((SELECT id FROM prescriptions WHERE prescription_code='RX-DEMO-02' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM medicines WHERE medicine_code='MED-DEMO-02' AND business_id=@business_id LIMIT 1),
 'Amoxicillin', '1-1-1', '7 days', 'After food', 21, 0);

-- 14. SALES (2 records)
INSERT INTO sales (
    business_id, branch_id, invoice_number, patient_id, prescription_id, invoice_date,
    cashier_id, subtotal, discount_amount, discount_pct, cgst_amount, sgst_amount,
    igst_amount, round_off, total_amount, paid_amount, change_amount, payment_mode,
    loyalty_points_used, loyalty_points_earned, is_gstin_bill, status, is_return,
    notes, created_at
) VALUES
(@business_id, @branch_id, 'INV-DEMO-01', (SELECT id FROM patients WHERE patient_code='PAT-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM prescriptions WHERE prescription_code='RX-DEMO-01' AND business_id=@business_id LIMIT 1), NOW(),
 (SELECT id FROM users WHERE username='pharmacist_demo1' LIMIT 1),
 250.00, 0.00, 0.00, 15.00, 15.00, 0.00, 0.00, 280.00, 280.00, 0.00, 'cash',
 0, 2, 0, 'confirmed', 0, 'Demo Sale 1', NOW()),
(@business_id, @branch_id, 'INV-DEMO-02', (SELECT id FROM patients WHERE patient_code='PAT-DEMO-02' AND business_id=@business_id LIMIT 1),
 NULL, NOW(),
 (SELECT id FROM users WHERE username='pharmacist_demo1' LIMIT 1),
 70.00, 0.00, 0.00, 4.20, 4.20, 0.00, 0.00, 78.40, 80.00, 1.60, 'cash',
 0, 0, 0, 'confirmed', 0, 'Demo Sale 2', NOW());

-- 15. SALE ITEMS (2 records)
INSERT INTO sale_items (
    sale_id, medicine_id, batch_id, quantity, mrp, selling_rate, discount_pct,
    gst_rate, cgst_amount, sgst_amount, igst_amount, total_amount
) VALUES
((SELECT id FROM sales WHERE invoice_number='INV-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM medicines WHERE medicine_code='MED-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM medicine_batches WHERE batch_number='BATCH-DEMO-01' LIMIT 1),
 10, 30.00, 25.00, 0.00, 12.00, 15.00, 15.00, 0.00, 280.00),
((SELECT id FROM sales WHERE invoice_number='INV-DEMO-02' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM medicines WHERE medicine_code='MED-DEMO-02' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM medicine_batches WHERE batch_number='BATCH-DEMO-02' LIMIT 1),
 1, 80.00, 70.00, 0.00, 12.00, 4.20, 4.20, 0.00, 78.40);

-- 16. SALES RETURNS (2 records)
INSERT INTO sales_returns (
    business_id, branch_id, return_number, original_sale_id, patient_id, return_date,
    reason, total_refund, refund_mode, processed_by, status
) VALUES
(@business_id, @branch_id, 'SRET-DEMO-01', (SELECT id FROM sales WHERE invoice_number='INV-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM patients WHERE patient_code='PAT-DEMO-01' AND business_id=@business_id LIMIT 1), NOW(),
 'Demo return reason 1', 28.00, 'cash',
 (SELECT id FROM users WHERE username='pharmacist_demo1' LIMIT 1), 'processed'),
(@business_id, @branch_id, 'SRET-DEMO-02', (SELECT id FROM sales WHERE invoice_number='INV-DEMO-02' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM patients WHERE patient_code='PAT-DEMO-02' AND business_id=@business_id LIMIT 1), NOW(),
 'Demo return reason 2', 78.40, 'cash',
 (SELECT id FROM users WHERE username='pharmacist_demo1' LIMIT 1), 'pending');

-- 17. SALES RETURN ITEMS (2 records)
INSERT INTO sales_return_items (return_id, sale_item_id, medicine_id, batch_id, quantity, refund_amount) VALUES
((SELECT id FROM sales_returns WHERE return_number='SRET-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT si.id FROM sale_items si JOIN sales s ON si.sale_id=s.id WHERE s.invoice_number='INV-DEMO-01' AND s.business_id=@business_id LIMIT 1),
 (SELECT id FROM medicines WHERE medicine_code='MED-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM medicine_batches WHERE batch_number='BATCH-DEMO-01' LIMIT 1), 1, 28.00),
((SELECT id FROM sales_returns WHERE return_number='SRET-DEMO-02' AND business_id=@business_id LIMIT 1),
 (SELECT si.id FROM sale_items si JOIN sales s ON si.sale_id=s.id WHERE s.invoice_number='INV-DEMO-02' AND s.business_id=@business_id LIMIT 1),
 (SELECT id FROM medicines WHERE medicine_code='MED-DEMO-02' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM medicine_batches WHERE batch_number='BATCH-DEMO-02' LIMIT 1), 1, 78.40);

-- 18. PURCHASE RETURNS (2 records)
INSERT INTO purchase_returns (
    business_id, branch_id, return_number, original_purchase_id, supplier_id, return_date,
    reason, total_amount, status, credit_note_number, created_at
) VALUES
(@business_id, @branch_id, 'PRET-DEMO-01', (SELECT id FROM purchases WHERE bill_number='PUR-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM suppliers WHERE supplier_code='SUP-DEMO-01' AND business_id=@business_id LIMIT 1), CURDATE(),
 'Demo purchase return 1', 150.00, 'pending', NULL, NOW()),
(@business_id, @branch_id, 'PRET-DEMO-02', (SELECT id FROM purchases WHERE bill_number='PUR-DEMO-02' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM suppliers WHERE supplier_code='SUP-DEMO-02' AND business_id=@business_id LIMIT 1), CURDATE(),
 'Demo purchase return 2', 450.00, 'credited', 'CN-DEMO-01', NOW());

-- 19. PURCHASE RETURN ITEMS (2 records)
INSERT INTO purchase_return_items (return_id, medicine_id, batch_id, quantity, rate, amount) VALUES
((SELECT id FROM purchase_returns WHERE return_number='PRET-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM medicines WHERE medicine_code='MED-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM medicine_batches WHERE batch_number='BATCH-DEMO-01' LIMIT 1), 10, 15.00, 150.00),
((SELECT id FROM purchase_returns WHERE return_number='PRET-DEMO-02' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM medicines WHERE medicine_code='MED-DEMO-02' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM medicine_batches WHERE batch_number='BATCH-DEMO-02' LIMIT 1), 10, 45.00, 450.00);

-- 20. STOCK ADJUSTMENTS (2 records)
INSERT INTO stock_adjustments (
    business_id, branch_id, adj_number, adj_type, reason, notes,
    adjusted_by, approved_by, status, created_at, updated_at
) VALUES
(@business_id, @branch_id, 'ADJ-DEMO-01', 'damage', 'Demo damage adjustment', 'Damaged in transit',
 (SELECT id FROM users WHERE username='admin_demo1' LIMIT 1),
 (SELECT id FROM users WHERE username='admin_demo1' LIMIT 1), 'approved', NOW(), NOW()),
(@business_id, @branch_id, 'ADJ-DEMO-02', 'correction', 'Demo correction adjustment', 'Stock count correction',
 (SELECT id FROM users WHERE username='pharmacist_demo1' LIMIT 1), NULL, 'pending', NOW(), NOW());

-- 21. STOCK ADJUSTMENT ITEMS (2 records)
INSERT INTO stock_adjustment_items (adjustment_id, batch_id, medicine_id, qty_before, qty_change, qty_after, reason, created_at) VALUES
((SELECT id FROM stock_adjustments WHERE adj_number='ADJ-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM medicine_batches WHERE batch_number='BATCH-DEMO-01' LIMIT 1),
 (SELECT id FROM medicines WHERE medicine_code='MED-DEMO-01' AND business_id=@business_id LIMIT 1), 100, -5, 95, 'Damaged units', NOW()),
((SELECT id FROM stock_adjustments WHERE adj_number='ADJ-DEMO-02' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM medicine_batches WHERE batch_number='BATCH-DEMO-02' LIMIT 1),
 (SELECT id FROM medicines WHERE medicine_code='MED-DEMO-02' AND business_id=@business_id LIMIT 1), 50, 2, 52, 'Count correction', NOW());

-- 22. COMPLIANCE RECORDS (2 records)
INSERT INTO compliance_records (
    business_id, branch_id, record_type, sale_id, medicine_id, patient_id, doctor_id,
    prescription_id, quantity_dispensed, dispensed_date, dispensed_by, batch_number, notes
) VALUES
(@business_id, @branch_id, 'schedule_h', (SELECT id FROM sales WHERE invoice_number='INV-DEMO-02' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM medicines WHERE medicine_code='MED-DEMO-02' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM patients WHERE patient_code='PAT-DEMO-02' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM doctors WHERE doctor_code='DOC-DEMO-02' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM prescriptions WHERE prescription_code='RX-DEMO-02' AND business_id=@business_id LIMIT 1),
 1, NOW(), (SELECT id FROM users WHERE username='pharmacist_demo1' LIMIT 1), 'BATCH-DEMO-02', 'Demo compliance 1'),
(@business_id, @branch_id, 'rx_log', (SELECT id FROM sales WHERE invoice_number='INV-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM medicines WHERE medicine_code='MED-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM patients WHERE patient_code='PAT-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM doctors WHERE doctor_code='DOC-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM prescriptions WHERE prescription_code='RX-DEMO-01' AND business_id=@business_id LIMIT 1),
 10, NOW(), (SELECT id FROM users WHERE username='pharmacist_demo1' LIMIT 1), 'BATCH-DEMO-01', 'Demo compliance 2');

-- 23. DRUG INTERACTIONS (2 records — no FK dependency)
INSERT INTO drug_interactions (drug_a_generic, drug_b_generic, severity, description, recommendation, source) VALUES
('Paracetamol', 'Amoxicillin', 'minor', 'Demo interaction description 1', 'Monitor patient', 'Demo Source'),
('Amoxicillin', 'Warfarin', 'major', 'Demo interaction description 2', 'Avoid combination', 'Demo Source');

-- 24. GST TRANSACTIONS (2 records)
INSERT INTO gst_transactions (
    business_id, branch_id, transaction_type, reference_id, reference_type, gstin,
    transaction_date, taxable_value, cgst_rate, cgst_amount, sgst_rate, sgst_amount,
    igst_rate, igst_amount, hsn_code, fy, period, filed, created_at
) VALUES
(@business_id, @branch_id, 'sale', (SELECT id FROM sales WHERE invoice_number='INV-DEMO-01' AND business_id=@business_id LIMIT 1), 'sale', NULL,
 CURDATE(), 250.00, 6.00, 15.00, 6.00, 15.00, 0.00, 0.00, '30049099', '2026-2027', '2026-07', 0, NOW()),
(@business_id, @branch_id, 'purchase', (SELECT id FROM purchases WHERE bill_number='PUR-DEMO-01' AND business_id=@business_id LIMIT 1), 'purchase', NULL,
 CURDATE(), 1500.00, 6.00, 90.00, 6.00, 90.00, 0.00, 0.00, '30049099', '2026-2027', '2026-07', 0, NOW());

-- 25. CHART OF ACCOUNTS (2 records)
INSERT INTO chart_of_accounts (business_id, code, name, type, parent_id, is_system, created_at) VALUES
(@business_id, 'DEMO-A1', 'Demo Cash Account', 'asset', NULL, 0, NOW()),
(@business_id, 'DEMO-R1', 'Demo Sales Revenue', 'revenue', NULL, 0, NOW());

-- 26. JOURNAL ENTRIES (2 records)
INSERT INTO journal_entries (
    business_id, branch_id, entry_number, entry_date, reference_type, reference_id,
    narration, total_debit, total_credit, created_by, created_at
) VALUES
(@business_id, @branch_id, 'JE-DEMO-01', CURDATE(), 'sale', (SELECT id FROM sales WHERE invoice_number='INV-DEMO-01' AND business_id=@business_id LIMIT 1),
 'Demo journal entry 1', 280.00, 280.00, (SELECT id FROM users WHERE username='admin_demo1' LIMIT 1), NOW()),
(@business_id, @branch_id, 'JE-DEMO-02', CURDATE(), 'purchase', (SELECT id FROM purchases WHERE bill_number='PUR-DEMO-01' AND business_id=@business_id LIMIT 1),
 'Demo journal entry 2', 1680.00, 1680.00, (SELECT id FROM users WHERE username='admin_demo1' LIMIT 1), NOW());

-- 27. JOURNAL ENTRY LINES (2 records)
INSERT INTO journal_entry_lines (entry_id, account_id, debit, credit) VALUES
((SELECT id FROM journal_entries WHERE entry_number='JE-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM chart_of_accounts WHERE code='DEMO-A1' AND business_id=@business_id LIMIT 1), 280.00, 0.00),
((SELECT id FROM journal_entries WHERE entry_number='JE-DEMO-02' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM chart_of_accounts WHERE code='DEMO-R1' AND business_id=@business_id LIMIT 1), 0.00, 1680.00);

-- 28. LOYALTY PROGRAM (only 1 allowed per business — unique business_id constraint)
INSERT INTO loyalty_programs (
    business_id, name, points_per_rupee, rupees_per_point, min_redeem_points, expiry_days,
    silver_min_spend, gold_min_spend, platinum_min_spend,
    silver_cashback_pct, gold_cashback_pct, platinum_cashback_pct,
    referral_bonus_points, is_active
) VALUES
(@business_id, 'Demo Loyalty Program', 1, 0.25, 100, 365, 0, 10000, 50000, 0, 2, 5, 50, 1);

-- 29. LOYALTY TRANSACTIONS (2 records)
INSERT INTO loyalty_transactions (patient_id, sale_id, type, points, balance, notes, created_at) VALUES
((SELECT id FROM patients WHERE patient_code='PAT-DEMO-01' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM sales WHERE invoice_number='INV-DEMO-01' AND business_id=@business_id LIMIT 1), 'earn', 2, 2, 'Demo loyalty earn', NOW()),
((SELECT id FROM patients WHERE patient_code='PAT-DEMO-02' AND business_id=@business_id LIMIT 1),
 (SELECT id FROM sales WHERE invoice_number='INV-DEMO-02' AND business_id=@business_id LIMIT 1), 'earn', 1, 1, 'Demo loyalty earn 2', NOW());

-- 30. NOTIFICATIONS (2 records)
INSERT INTO notifications (
    business_id, branch_id, user_id, type, title, message, reference_type, reference_id,
    is_read, priority, sent_via, created_at
) VALUES
(@business_id, @branch_id, (SELECT id FROM users WHERE username='admin_demo1' LIMIT 1), 'low_stock',
 'Demo Low Stock Alert', 'Demo medicine running low', 'medicine',
 (SELECT id FROM medicines WHERE medicine_code='MED-DEMO-01' AND business_id=@business_id LIMIT 1), 0, 'high', NULL, NOW()),
(@business_id, @branch_id, (SELECT id FROM users WHERE username='pharmacist_demo1' LIMIT 1), 'expiry',
 'Demo Expiry Alert', 'Demo batch nearing expiry', 'batch',
 (SELECT id FROM medicine_batches WHERE batch_number='BATCH-DEMO-02' LIMIT 1), 0, 'medium', NULL, NOW());

-- 31. WHATSAPP LOGS (2 records)
INSERT INTO whatsapp_logs (
    business_id, patient_id, to_number, message_type, reference_type, reference_id,
    message_body, status, error_message, sent_by, created_at
) VALUES
(@business_id, (SELECT id FROM patients WHERE patient_code='PAT-DEMO-01' AND business_id=@business_id LIMIT 1), '9222000001', 'invoice',
 'sale', (SELECT id FROM sales WHERE invoice_number='INV-DEMO-01' AND business_id=@business_id LIMIT 1),
 'Demo invoice message', 'sent', NULL, (SELECT id FROM users WHERE username='admin_demo1' LIMIT 1), NOW()),
(@business_id, (SELECT id FROM patients WHERE patient_code='PAT-DEMO-02' AND business_id=@business_id LIMIT 1), '9222000002', 'payment_reminder',
 'sale', (SELECT id FROM sales WHERE invoice_number='INV-DEMO-02' AND business_id=@business_id LIMIT 1),
 'Demo reminder message', 'queued', NULL, (SELECT id FROM users WHERE username='admin_demo1' LIMIT 1), NOW());

-- 32. AI CHAT LOGS (2 records)
INSERT INTO ai_chat_logs (business_id, user_id, question, answer, intent, created_at) VALUES
(@business_id, (SELECT id FROM users WHERE username='admin_demo1' LIMIT 1), 'Demo question 1', 'Demo answer 1', 'stock_query', NOW()),
(@business_id, (SELECT id FROM users WHERE username='pharmacist_demo1' LIMIT 1), 'Demo question 2', 'Demo answer 2', 'sales_query', NOW());

-- 33. AUDIT LOGS (2 records)
INSERT INTO audit_logs (
    user_id, action, module, description, record_type, record_id,
    severity, created_at
) VALUES
((SELECT id FROM users WHERE username='admin_demo1' LIMIT 1), 'create', 'users', 'Demo audit log 1',
 'User', (SELECT id FROM users WHERE username='pharmacist_demo1' LIMIT 1), 'info', NOW()),
((SELECT id FROM users WHERE username='pharmacist_demo1' LIMIT 1), 'create', 'sales', 'Demo audit log 2',
 'Sale', (SELECT id FROM sales WHERE invoice_number='INV-DEMO-01' AND business_id=@business_id LIMIT 1), 'info', NOW());

-- 34. SEQUENCES (2 records — no FK dependency)
INSERT INTO sequences (`key`, current_value, prefix, pad_length, reset_yearly, last_reset_year, created_at, updated_at) VALUES
('demo_seq_1', 1, 'DS1', 6, 0, YEAR(CURDATE()), NOW(), NOW()),
('demo_seq_2', 1, 'DS2', 6, 0, YEAR(CURDATE()), NOW(), NOW());

-- =====================================================================
-- DONE. Login with: username = admin_demo1, password = Admin@123
-- =====================================================================
