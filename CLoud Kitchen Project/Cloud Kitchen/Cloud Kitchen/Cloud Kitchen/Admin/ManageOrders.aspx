<%@ Page Title="Manage Orders" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Admin.Master"
    CodeBehind="ManageOrders.aspx.vb" Inherits="Cloud_Kitchen.WebForm11" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <!-- FontAwesome Vector Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

        <style type="text/css">
            .admin-container {
                width: min(100%, 1440px);
                margin: 0 auto;
                font-family: 'Segoe UI', system-ui, -apple-system, BlinkMacSystemFont, Roboto, sans-serif;
                padding: clamp(16px, 2vw, 24px);
                background: linear-gradient(to bottom right, #f8fdff, #f1f5f9);
                border-radius: 14px;
                box-shadow: 0px 8px 24px rgba(0, 0, 0, 0.06);
                position: relative;
            }

            .dashboard-summary {
                display: grid;
                grid-template-columns: repeat(4, minmax(0, 1fr));
                gap: clamp(12px, 1.8vw, 18px);
                margin-bottom: 22px;
            }

            .summary-card {
                background: white;
                padding: 16px 20px;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
                border: 1px solid #e2e8f0;
                display: flex;
                align-items: center;
                gap: 14px;
                transition: transform 0.25s, box-shadow 0.25s;
            }

            .summary-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
            }

            .summary-card img {
                width: 38px;
                height: 38px;
                object-fit: contain;
            }

            .summary-value {
                font-size: 1.7rem;
                font-weight: 800;
                line-height: 1.1;
                color: #0f172a;
            }

            .summary-label {
                font-size: 12px;
                font-weight: 700;
                color: #64748b;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .filters {
                display: grid;
                grid-template-columns: minmax(140px, 0.7fr) minmax(140px, 0.7fr) minmax(280px, 1.3fr) minmax(280px, 1.3fr);
                align-items: end;
                gap: 14px;
                margin-bottom: 22px;
                background: white;
                padding: 18px 22px;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
                border: 1px solid #e2e8f0;
            }

            .filter-group {
                display: flex;
                flex-direction: column;
                gap: 6px;
            }

            .filter-label {
                font-weight: 700;
                color: #475569;
                font-size: 13px;
                white-space: nowrap;
            }

            .date-filter {
                display: grid;
                grid-template-columns: minmax(0, 1fr) auto minmax(0, 1fr);
                gap: 8px;
                align-items: center;
                width: 100%;
            }

            .styled-dropdown,
            .styled-input {
                width: 100% !important;
                min-height: 42px;
                padding: 8px 12px;
                font-size: 13.5px;
                border: 1.5px solid #cbd5e1;
                border-radius: 8px;
                background: #ffffff;
                transition: border-color 0.25s, box-shadow 0.25s;
                outline: none;
            }

            .styled-dropdown:focus,
            .styled-input:focus {
                border-color: #2563eb;
                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
            }

            .btn-filter {
                min-height: 42px;
                padding: 10px 20px;
                font-size: 14px;
                font-weight: 700;
                color: #fff;
                background: linear-gradient(135deg, #2563eb, #1d4ed8);
                border: none;
                border-radius: 8px;
                cursor: pointer;
                transition: transform 0.2s, box-shadow 0.2s;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                white-space: nowrap;
                box-shadow: 0 4px 12px rgba(37, 99, 235, 0.22);
            }

            .btn-filter:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 16px rgba(37, 99, 235, 0.32);
            }

            /* SPLIT MASTER-DETAIL CONTAINER */
            .split-master-detail-container {
                display: flex;
                gap: 20px;
                align-items: flex-start;
                margin-bottom: 24px;
            }

            /* LEFT MASTER PANE (35% WIDTH) */
            .master-pane {
                flex: 0 0 35%;
                max-width: 35%;
                background: #ffffff;
                border-radius: 14px;
                border: 1.5px solid #e2e8f0;
                box-shadow: 0 4px 18px rgba(0, 0, 0, 0.04);
                display: flex;
                flex-direction: column;
                overflow: hidden;
                height: auto;
            }

            .master-header {
                padding: 16px 20px;
                background: #f8fafc;
                border-bottom: 1.5px solid #e2e8f0;
                font-weight: 800;
                font-size: 15px;
                color: #0f172a;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .master-scroll-body::-webkit-scrollbar {
                width: 6px;
            }

            .master-scroll-body::-webkit-scrollbar-track {
                background: transparent;
            }

            .master-scroll-body::-webkit-scrollbar-thumb {
                background: #cbd5e1;
                border-radius: 10px;
            }

            .master-scroll-body::-webkit-scrollbar-thumb:hover {
                background: #94a3b8;
            }

            .master-scroll-body {
                flex: 1;
                max-height: calc(100vh - 250px);
                overflow-y: auto;
                padding: 14px;
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            /* MASTER LIST CARD */
            .master-item-card {
                background: #ffffff;
                border: 1.5px solid #e2e8f0;
                border-radius: 12px;
                padding: 14px;
                cursor: pointer;
                transition: all 0.2s ease-in-out;
                position: relative;
            }

            .master-item-card:hover {
                border-color: #94a3b8;
                box-shadow: 0 4px 14px rgba(0, 0, 0, 0.06);
            }

            .master-item-card.selected {
                border-color: #2563eb;
                background: #eff6ff;
                box-shadow: 0 4px 16px rgba(37, 99, 235, 0.14);
            }

            .master-item-card.selected::before {
                content: '';
                position: absolute;
                left: 0;
                top: 0;
                bottom: 0;
                width: 5px;
                background: #2563eb;
                border-top-left-radius: 10px;
                border-bottom-left-radius: 10px;
            }

            .master-card-top {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 6px;
            }

            .master-order-id {
                font-weight: 800;
                font-size: 14px;
                color: #1e293b;
            }

            .master-order-date {
                font-size: 11px;
                color: #64748b;
                font-weight: 600;
            }

            .master-card-middle {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 6px;
            }

            .master-cust-name {
                font-weight: 700;
                font-size: 13px;
                color: #0f172a;
            }

            .master-card-bottom {
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-size: 12px;
            }

            .master-price-tag {
                font-weight: 800;
                color: #16a34a;
                font-size: 14px;
            }

            /* STATUS BADGES & FIFO PRIORITY BADGES */
            .status-pill {
                padding: 3px 10px;
                border-radius: 20px;
                font-size: 11px;
                font-weight: 800;
                display: inline-flex;
                align-items: center;
                gap: 5px;
            }

            .pill-pending {
                background: #fefce8;
                color: #a16207;
                border: 1px solid #fef08a;
            }

            .pill-preparing {
                background: #eff6ff;
                color: #1d4ed8;
                border: 1px solid #bfdbfe;
            }

            .pill-dispatched {
                background: #fff7ed;
                color: #c2410c;
                border: 1px solid #ffedd5;
            }

            .pill-completed {
                background: #f0fdf4;
                color: #15803d;
                border: 1px solid #bbf7d0;
            }

            .pill-cancelled {
                background: #fef2f2;
                color: #b91c1c;
                border: 1px solid #fecaca;
            }

            .fifo-badge {
                font-size: 10px;
                font-weight: 800;
                padding: 2px 7px;
                border-radius: 12px;
                display: inline-flex;
                align-items: center;
                gap: 4px;
            }

            .fifo-fresh {
                background: #ecfdf5;
                color: #047857;
                border: 1px solid #a7f3d0;
            }

            .fifo-waiting {
                background: #fef3c7;
                color: #b45309;
                border: 1px solid #fde68a;
            }

            .fifo-urgent {
                background: #fee2e2;
                color: #b91c1c;
                border: 1px solid #fca5a5;
                animation: pulse 1.5s infinite;
            }

            @keyframes pulse {
                0% {
                    opacity: 1;
                }

                50% {
                    opacity: 0.6;
                }

                100% {
                    opacity: 1;
                }
            }

            /* RIGHT DETAIL PANE (65% WIDTH) */
            /* RIGHT DETAIL PANE (65% WIDTH) */
            .detail-pane {
                flex: 1;
                min-width: 0;
                background: #ffffff;
                border-radius: 14px;
                border: 1.5px solid #e2e8f0;
                box-shadow: 0 4px 18px rgba(0, 0, 0, 0.04);
                padding: clamp(18px, 2.2vw, 28px);
                display: flex;
                flex-direction: column;
                gap: 20px;
                height: auto;
            }

            .detail-header-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding-bottom: 16px;
                border-bottom: 1.5px solid #e2e8f0;
                flex-wrap: wrap;
                gap: 12px;
            }

            .detail-title {
                font-size: 1.35rem;
                font-weight: 800;
                color: #0f172a;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .detail-info-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 16px;
                background: #f8fafc;
                border-radius: 12px;
                padding: 16px 20px;
                border: 1px solid #e2e8f0;
            }

            .info-box-title {
                font-size: 12px;
                font-weight: 800;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                color: #64748b;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                gap: 6px;
            }

            .cust-profile-row {
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .cust-avatar-large {
                width: 44px;
                height: 44px;
                background: linear-gradient(135deg, #2563eb, #1d4ed8);
                color: #ffffff;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 18px;
                font-weight: 800;
            }

            .cust-name-lg {
                font-weight: 800;
                font-size: 15px;
                color: #0f172a;
            }

            .btn-call-cust {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 4px 12px;
                border-radius: 20px;
                background: #dbeafe;
                color: #1e40af;
                font-size: 12px;
                font-weight: 700;
                text-decoration: none;
                margin-top: 4px;
            }

            .btn-call-cust:hover {
                background: #bfdbfe;
            }

            /* ITEMIZED RECEIPT TABLE */
            .receipt-card {
                background: #ffffff;
                border: 1.5px solid #e2e8f0;
                border-radius: 12px;
                overflow: hidden;
            }

            .receipt-table {
                width: 100%;
                border-collapse: collapse;
                font-size: 13px;
            }

            .receipt-table th {
                background: #f1f5f9;
                padding: 12px 16px;
                text-align: left;
                font-weight: 800;
                color: #475569;
                border-bottom: 1.5px solid #e2e8f0;
            }

            .receipt-table td {
                padding: 12px 16px;
                border-bottom: 1px solid #f1f5f9;
                color: #334155;
            }

            .receipt-summary-box {
                background: #f8fafc;
                padding: 14px 20px;
                display: flex;
                flex-direction: column;
                gap: 6px;
                align-items: flex-end;
                border-top: 1.5px solid #e2e8f0;
            }

            .summary-row {
                display: flex;
                justify-content: space-between;
                width: 240px;
                font-size: 13px;
                color: #64748b;
            }

            .summary-row.grand-total {
                font-size: 16px;
                font-weight: 800;
                color: #0f172a;
                border-top: 1.5px solid #cbd5e1;
                padding-top: 6px;
                margin-top: 4px;
            }

            .summary-row.grand-total .amount {
                color: #2563eb;
            }

            /* ACTION CONTROLS BAR */
            .detail-actions-panel {
                background: #f8fafc;
                border-radius: 12px;
                padding: 16px 20px;
                border: 1.5px solid #e2e8f0;
                display: flex;
                flex-direction: column;
                gap: 12px;
            }

            .action-button-row {
                display: flex;
                gap: 12px;
                flex-wrap: wrap;
            }

            .btn-action-main {
                padding: 10px 22px;
                font-size: 14px;
                font-weight: 700;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                transition: all 0.2s;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            }

            .btn-action-main:hover {
                transform: translateY(-2px);
            }

            .btn-accept-main {
                background: linear-gradient(135deg, #2563eb, #1d4ed8);
                color: #fff;
                box-shadow: 0 4px 14px rgba(37, 99, 235, 0.3);
            }

            .btn-dispatch-main {
                background: linear-gradient(135deg, #2563eb, #1d4ed8);
                color: #fff;
                box-shadow: 0 4px 14px rgba(37, 99, 235, 0.3);
            }

            .btn-complete-main {
                background: linear-gradient(135deg, #10b981, #059669);
                color: #fff;
                box-shadow: 0 4px 14px rgba(16, 185, 129, 0.3);
            }

            .btn-cancel-main {
                background: #fef2f2;
                color: #dc2626;
                border: 1.5px solid #fca5a5;
            }

            .btn-cancel-main:hover {
                background: #fee2e2;
                color: #b91c1c;
            }

            .btn-print-main {
                background: #f8fafc;
                color: #334155;
                border: 1.5px solid #cbd5e1;
            }

            .workflow-actions-bar {
                display: flex;
                flex-wrap: wrap;
                align-items: center;
                gap: 10px;
                width: 100%;
                margin-top: 8px;
            }

            .workflow-actions-bar .btn-action-main {
                flex: 1 1 auto;
                min-width: 135px;
                height: 42px;
                padding: 0 16px;
                margin: 0;
                white-space: nowrap;
                text-align: center;
                justify-content: center;
            }

            /* BACK BUTTON FOR MOBILE */
            .mobile-back-btn {
                display: none;
                padding: 6px 14px;
                border-radius: 8px;
                background: #e2e8f0;
                color: #334155;
                font-weight: 700;
                font-size: 13px;
                border: none;
                cursor: pointer;
                margin-bottom: 12px;
                align-items: center;
                gap: 6px;
            }

            /* RESPONSIVE LAYOUT */
            @media (max-width: 991px) {
                .dashboard-summary {
                    grid-template-columns: repeat(2, 1fr) !important;
                    gap: 12px !important;
                }

                .filters {
                    grid-template-columns: 1fr 1fr;
                }

                .split-master-detail-container {
                    flex-direction: column !important;
                    align-items: stretch !important;
                    width: 100% !important;
                }

                .master-pane {
                    flex: 1 1 100% !important;
                    max-width: 100% !important;
                    width: 100% !important;
                    box-sizing: border-box !important;
                }

                .master-scroll-body {
                    width: 100% !important;
                    box-sizing: border-box !important;
                }

                .master-item-card {
                    width: 100% !important;
                    box-sizing: border-box !important;
                }

                .detail-pane {
                    flex: 1 1 100% !important;
                    max-height: none !important;
                    width: 100% !important;
                    box-sizing: border-box !important;
                }

                /* Mobile View Toggle Classes */
                .split-master-detail-container.mobile-show-detail .master-pane {
                    display: none !important;
                }

                .split-master-detail-container.mobile-show-detail .detail-pane {
                    display: flex !important;
                }

                .split-master-detail-container.mobile-show-master .master-pane {
                    display: flex !important;
                }

                .split-master-detail-container.mobile-show-master .detail-pane {
                    display: none !important;
                }

                .mobile-back-btn {
                    display: inline-flex !important;
                }

                .detail-info-grid {
                    grid-template-columns: 1fr;
                }
            }

            @media (max-width: 600px) {
                .filters {
                    grid-template-columns: 1fr;
                }

                .dashboard-summary {
                    grid-template-columns: repeat(2, 1fr) !important;
                    gap: 10px !important;
                }

                .summary-card {
                    padding: 12px 10px !important;
                    gap: 8px !important;
                }

                .summary-card img {
                    width: 30px !important;
                    height: 30px !important;
                }

                .summary-value {
                    font-size: 1.35rem !important;
                }

                .summary-label {
                    font-size: 10px !important;
                    letter-spacing: 0.2px !important;
                }
            }
        </style>

        <script type="text/javascript">
            var lastMobileViewMode = 'master';

            function showMobileDetail() {
                lastMobileViewMode = 'detail';
                var container = document.querySelector('.split-master-detail-container');
                var master = document.querySelector('.master-pane');
                var detail = document.querySelector('.detail-pane');

                if (container) {
                    container.classList.remove('mobile-show-master');
                    container.classList.add('mobile-show-detail');
                }
                if (window.innerWidth <= 991) {
                    if (master) master.style.display = 'none';
                    if (detail) detail.style.display = 'flex';
                    window.scrollTo({ top: 120, behavior: 'smooth' });
                }
            }

            function showMobileMaster() {
                lastMobileViewMode = 'master';
                var container = document.querySelector('.split-master-detail-container');
                var master = document.querySelector('.master-pane');
                var detail = document.querySelector('.detail-pane');

                if (container) {
                    container.classList.remove('mobile-show-detail');
                    container.classList.add('mobile-show-master');
                }
                if (window.innerWidth <= 991) {
                    if (master) master.style.display = 'flex';
                    if (detail) detail.style.display = 'none';
                    window.scrollTo({ top: 120, behavior: 'smooth' });
                }
            }

            // Restore mobile view state after ASP.NET UpdatePanel partial postbacks
            if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
                var prm = Sys.WebForms.PageRequestManager.getInstance();
                prm.add_endRequest(function (sender, args) {
                    if (window.innerWidth <= 991) {
                        if (lastMobileViewMode === 'detail') {
                            showMobileDetail();
                        } else {
                            showMobileMaster();
                        }
                    }
                });
            }

            // =========================================================================
            // HIGH-QUALITY THERMAL POS RECEIPT PRINT FUNCTION
            // =========================================================================
            function printThermalInvoice() {
                function getVal(selector) {
                    var el = document.querySelector(selector);
                    return el ? el.innerText.trim() : '';
                }

                var orderId = getVal('.val-order-id');
                var orderDate = getVal('.val-order-date');
                var custName = getVal('.val-cust-name');
                var custPhone = getVal('.val-cust-phone');
                var address = getVal('.val-address');
                var payment = getVal('.val-payment');
                var subtotal = getVal('.val-subtotal');
                var tax = getVal('.val-tax');
                var grandTotal = getVal('.val-grandtotal');

                var driverName = getVal('.val-driver-name');
                var driverOtp = getVal('.val-driver-otp');

                // Extract Itemized Dishes Table Rows
                var itemsHtml = '';
                var receiptTable = document.querySelector('.receipt-table tbody');
                if (receiptTable) {
                    var rows = receiptTable.querySelectorAll('tr');
                    rows.forEach(function (row) {
                        var cols = row.querySelectorAll('td');
                        if (cols.length >= 4) {
                            var itemName = cols[0].innerText.trim();
                            var qty = cols[1].innerText.trim();
                            var price = cols[2].innerText.trim();
                            var total = cols[3].innerText.trim();
                            itemsHtml += '<tr>' +
                                '<td style="padding:6px 0; text-align:left;">' + itemName + '</td>' +
                                '<td style="padding:6px 0; text-align:center;">' + qty + '</td>' +
                                '<td style="padding:6px 0; text-align:right;">' + price + '</td>' +
                                '<td style="padding:6px 0; text-align:right; font-weight:bold;">' + total + '</td>' +
                                '</tr>';
                        }
                    });
                }

                var printWin = window.open('', '', 'width=420,height=700');
                var doc = printWin.document;
                doc.open();
                doc.write('<html><head><title>POS Receipt #' + orderId + '</title>');
                doc.write('<style>');
                doc.write('  @page { size: 80mm auto; margin: 0; }');
                doc.write('  body { font-family: "Courier New", Courier, monospace; width: 300px; margin: 0 auto; padding: 15px; color: #000; font-size: 12px; line-height: 1.3; }');
                doc.write('  .text-center { text-align: center; }');
                doc.write('  .text-right { text-align: right; }');
                doc.write('  .bold { font-weight: bold; }');
                doc.write('  .header-logo { font-size: 20px; font-weight: 900; letter-spacing: 1px; margin-bottom: 2px; }');
                doc.write('  .divider-double { border-top: 2px dashed #000; margin: 8px 0; }');
                doc.write('  .divider-single { border-top: 1px dashed #000; margin: 6px 0; }');
                doc.write('  .item-table { width: 100%; border-collapse: collapse; margin: 8px 0; font-size: 11px; }');
                doc.write('  .summary-table { width: 100%; margin-top: 6px; font-size: 12px; }');
                doc.write('  .grand-total-row { font-size: 15px; font-weight: bold; border-top: 1px dashed #000; border-bottom: 1px dashed #000; padding: 6px 0; }');
                doc.write('  .otp-box { background: #000; color: #fff; padding: 4px 8px; font-weight: bold; display: inline-block; margin-top: 4px; font-size: 13px; }');
                doc.write('  .btn-print-trigger { background: #000; color: #fff; border: none; padding: 10px; width: 100%; font-weight: bold; font-size: 14px; cursor: pointer; margin-top: 15px; border-radius: 4px; }');
                doc.write('  @media print { .btn-print-trigger { display: none; } }');
                doc.write('</style>');
                doc.write('</head><body>');

                // BRANDING HEADER
                doc.write('<div class="text-center">');
                doc.write('  <div class="header-logo">🍳 CLOUD KITCHEN</div>');
                doc.write('  <div>102, Food Park, Vallabh Vidyanagar</div>');
                doc.write('  <div>Ph: +91 98765 43210 | GSTIN: 24ABCDE1234F</div>');
                doc.write('</div>');
                doc.write('<div class="divider-double"></div>');

                // INVOICE & CUSTOMER INFO
                doc.write('<div>');
                doc.write('  <div><strong>INVOICE NO:</strong> #' + orderId + '</div>');
                doc.write('  <div><strong>DATE:</strong> ' + orderDate + '</div>');
                doc.write('  <div><strong>CUSTOMER:</strong> ' + custName + '</div>');
                if (custPhone) doc.write('  <div><strong>PHONE:</strong> ' + custPhone + '</div>');
                doc.write('  <div><strong>ADDRESS:</strong> ' + address + '</div>');
                doc.write('  <div><strong>PAYMENT:</strong> ' + payment + '</div>');
                doc.write('</div>');
                doc.write('<div class="divider-single"></div>');

                // ITEMS TABLE
                doc.write('<table class="item-table">');
                doc.write('  <thead>');
                doc.write('    <tr style="border-bottom: 1px dashed #000;">');
                doc.write('      <th style="text-align:left;">ITEM</th>');
                doc.write('      <th style="text-align:center;">QTY</th>');
                doc.write('      <th style="text-align:right;">PRICE</th>');
                doc.write('      <th style="text-align:right;">TOTAL</th>');
                doc.write('    </tr>');
                doc.write('  </thead>');
                doc.write('  <tbody>' + itemsHtml + '</tbody>');
                doc.write('</table>');
                doc.write('<div class="divider-single"></div>');

                // BILLING BREAKDOWN
                doc.write('<table class="summary-table">');
                doc.write('  <tr class="grand-total-row"><td>TOTAL AMOUNT:</td><td class="text-right">' + grandTotal + '</td></tr>');
                doc.write('</table>');
                doc.write('<div style="text-align:right; font-size:10px; color:#555; margin-top:2px;">(Incl. of all taxes & GST)</div>');

                // DRIVER & OTP INFO IF DISPATCHED
                if (driverName && driverName !== 'Assigned Driver') {
                    doc.write('<div class="divider-single"></div>');
                    doc.write('<div>');
                    doc.write('  <div><strong>DRIVER:</strong> ' + driverName + '</div>');
                    if (driverOtp) doc.write('  <div class="otp-box">DELIVERY OTP: ' + driverOtp + '</div>');
                    doc.write('</div>');
                }

                // FOOTER & BARCODE
                doc.write('<div class="divider-double"></div>');
                doc.write('<div class="text-center">');
                doc.write('  <div style="letter-spacing:4px; font-weight:bold; font-size:16px;">||||| | ||||| |||| ||</div>');
                doc.write('  <div style="margin-top:6px; font-weight:bold;">THANK YOU FOR YOUR ORDER!</div>');
                doc.write('  <div style="font-size:10px;">Visit Again @ Cloud Kitchen</div>');
                doc.write('</div>');

                doc.write('<button class="btn-print-trigger" onclick="window.print();">🖨️ PRINT THERMAL RECEIPT</button>');
                doc.write('</body></html>');
                doc.close();

                setTimeout(function () {
                    printWin.print();
                }, 300);
            }
        </script>
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <div class="admin-container">

            <!-- TOP DASHBOARD METRICS CARDS -->
            <div class="dashboard-summary">
                <div class="summary-card">
                    <img src="../icons/pen.png" alt="Pending" />
                    <div>
                        <div class="summary-value">
                            <asp:Literal ID="litPendingOrders" runat="server">0</asp:Literal>
                        </div>
                        <div class="summary-label">Pending</div>
                    </div>
                </div>

                <div class="summary-card">
                    <img src="../icons/comm1.png" alt="Completed" />
                    <div>
                        <div class="summary-value">
                            <asp:Literal ID="litCompletedOrders" runat="server">0</asp:Literal>
                        </div>
                        <div class="summary-label">Completed</div>
                    </div>
                </div>

                <div class="summary-card">
                    <img src="../icons/c3.png" alt="Cancelled" />
                    <div>
                        <div class="summary-value">
                            <asp:Literal ID="litCancelledOrders" runat="server">0</asp:Literal>
                        </div>
                        <div class="summary-label">Cancelled</div>
                    </div>
                </div>

                <div class="summary-card">
                    <img src="../icons/total.png" alt="Total" />
                    <div>
                        <div class="summary-value">
                            <asp:Literal ID="litTotalOrders" runat="server">0</asp:Literal>
                        </div>
                        <div class="summary-label">Total Orders</div>
                    </div>
                </div>
            </div>

            <!-- ENHANCED FILTERS BAR WITH QUICK DATE PRESETS -->
            <div class="filters">
                <div class="filter-group">
                    <span class="filter-label">Order Stage:</span>
                    <asp:DropDownList ID="ddlFilterStatus" runat="server" AutoPostBack="true" CssClass="styled-dropdown"
                        OnSelectedIndexChanged="ddlFilterStatus_SelectedIndexChanged">
                        <asp:ListItem Text="All Orders" Value=""></asp:ListItem>
                        <asp:ListItem Text="⏳ Pending" Value="Pending"></asp:ListItem>
                        <asp:ListItem Text="🧑‍🍳 Preparing" Value="Preparing"></asp:ListItem>
                        <asp:ListItem Text="🛵 Out for Delivery" Value="Out for Delivery"></asp:ListItem>
                        <asp:ListItem Text="✅ Completed" Value="Completed"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="filter-group">
                    <span class="filter-label">Date Preset:</span>
                    <asp:DropDownList ID="ddlQuickDate" runat="server" AutoPostBack="true" CssClass="styled-dropdown"
                        OnSelectedIndexChanged="ddlQuickDate_SelectedIndexChanged">
                        <asp:ListItem Text="Last 30 Days" Value="30days" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Today Only" Value="today"></asp:ListItem>
                        <asp:ListItem Text="Yesterday" Value="yesterday"></asp:ListItem>
                        <asp:ListItem Text="Last 7 Days" Value="7days"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="filter-group">
                    <span class="filter-label">Custom Date Range:</span>
                    <div class="date-filter">
                        <asp:TextBox ID="txtStartDate" runat="server" CssClass="styled-input" TextMode="Date">
                        </asp:TextBox>
                        <span>-</span>
                        <asp:TextBox ID="txtEndDate" runat="server" CssClass="styled-input" TextMode="Date">
                        </asp:TextBox>
                    </div>
                </div>

                <div class="filter-group">
                    <span class="filter-label">Search Keyword:</span>
                    <div style="display:flex; gap:8px;">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="styled-input"
                            placeholder="Search Order #, Name, Phone"></asp:TextBox>
                        <asp:Button ID="btnFilter" runat="server" Text="Filter" OnClick="btnFilter_Click"
                            CssClass="btn-filter"></asp:Button>
                    </div>
                </div>
            </div>

            <!-- HIDDEN REPEATERS FOR BACKWARD COMPATIBILITY -->
            <asp:Repeater ID="rptOrders" runat="server" Visible="false"></asp:Repeater>
            <asp:Repeater ID="rptPending" runat="server" Visible="false"></asp:Repeater>
            <asp:Repeater ID="rptPreparing" runat="server" Visible="false"></asp:Repeater>
            <asp:Repeater ID="rptDispatched" runat="server" Visible="false"></asp:Repeater>
            <asp:Repeater ID="rptCompleted" runat="server" Visible="false"></asp:Repeater>
            <asp:Literal ID="litPendingCount" runat="server" Visible="false"></asp:Literal>
            <asp:Literal ID="litPreparingCount" runat="server" Visible="false"></asp:Literal>
            <asp:Literal ID="litDispatchedCount" runat="server" Visible="false"></asp:Literal>
            <asp:Literal ID="litCompletedCount" runat="server" Visible="false"></asp:Literal>

            <!-- NO ORDERS FOUND MESSAGE -->
            <asp:Panel ID="pnlNoOrders" runat="server" CssClass="empty-swimlane"
                style="background:#fff; border-radius:12px; padding:30px; margin-bottom:20px; box-shadow:0 4px 12px rgba(0,0,0,0.04);"
                Visible="false">
                <p style="font-size:16px; color:#64748b; margin:0;"><i class="fas fa-search"
                        style="margin-right: 8px;"></i> No orders found matching your filter criteria. Adjust filters
                    above.</p>
            </asp:Panel>

            <!-- ====================================================================
             OPTION 3: SPLIT MASTER-DETAIL VIEW CONTAINER (NATURAL PAGE RELOAD)
        ==================================================================== -->
            <div class="split-master-detail-container">

                <!-- LEFT MASTER PANE (35% WIDTH) -->
                <div class="master-pane">
                    <div class="master-header">
                        <span><i class="fas fa-list-ul" style="color:#2563eb; margin-right:6px;"></i> Order Queue
                        </span>
                        <span style="font-size:11px; color:#64748b; font-weight:600;">Click item to view</span>
                    </div>
                    <div class="master-scroll-body">
                        <asp:Repeater ID="rptMasterOrders" runat="server" OnItemCommand="rptMasterOrders_ItemCommand">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkSelectOrder" runat="server" CommandName="SelectOrder"
                                    CommandArgument='<%# Eval("order_id") %>' style="text-decoration:none;"
                                    OnClientClick="showMobileDetail();">
                                    <div
                                        class='<%# IIf(Convert.ToBoolean(Eval("IsSelected")), "master-item-card selected", "master-item-card") %>'>
                                        <div class="master-card-top">
                                            <span class="master-order-id"><i class="fas fa-box"
                                                    style="color:#64748b; font-size:12px;"></i> Order #<%#
                                                    Eval("order_id") %></span>
                                            <span class="master-order-date">
                                                <%# Eval("order_date", "{0:hh:mm tt}" ) %>
                                            </span>
                                        </div>
                                        <div class="master-card-middle">
                                            <span class="master-cust-name">
                                                <%# Eval("customer_name") %>
                                            </span>
                                            <%# FormatMasterStatusPill(Eval("order_status").ToString()) %>
                                        </div>
                                        <div class="master-card-bottom">
                                            <span style="color:#64748b; font-size:11px;"><i
                                                    class="fas fa-credit-card"></i>
                                                <%# Eval("payment_type") %>
                                            </span>
                                            <div style="display:flex; align-items:center; gap:6px;">
                                                <%# GetFifoWaitBadge(Eval("order_date"),
                                                    Eval("order_status").ToString()) %>
                                                    <span class="master-price-tag">₹<%# Eval("total_amount", "{0:N2}" )
                                                            %></span>
                                            </div>
                                        </div>
                                    </div>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>

                <!-- RIGHT DETAIL PANE (65% WIDTH) -->
                <asp:Panel ID="pnlDetailView" runat="server" CssClass="detail-pane">

                    <button type="button" class="mobile-back-btn" onclick="showMobileMaster();">
                        <i class="fas fa-arrow-left"></i> Back to Orders List
                    </button>

                    <!-- DETAIL HEADER BAR -->
                    <div class="detail-header-bar">
                        <div>
                            <h2 class="detail-title">
                                <i class="fas fa-receipt" style="color:#2563eb;"></i> Order #<span class="val-order-id">
                                    <asp:Literal ID="litDetailOrderId" runat="server"></asp:Literal>
                                </span>
                            </h2>
                            <span style="font-size:12px; color:#64748b; font-weight:600;">
                                Placed on <span class="val-order-date">
                                    <asp:Literal ID="litDetailOrderDate" runat="server"></asp:Literal>
                                </span>
                            </span>
                        </div>
                        <div>
                            <asp:Literal ID="litDetailStatusBadge" runat="server"></asp:Literal>
                        </div>
                    </div>

                    <!-- CUSTOMER & DELIVERY ADDRESS BOX -->
                    <div class="detail-info-grid">
                        <div>
                            <div class="info-box-title"><i class="fas fa-user-circle"></i> Customer Information</div>
                            <div class="cust-profile-row">
                                <div class="cust-avatar-large">
                                    <asp:Literal ID="litDetailCustAvatar" runat="server">U</asp:Literal>
                                </div>
                                <div>
                                    <div class="cust-name-lg"><span class="val-cust-name">
                                            <asp:Literal ID="litDetailCustName" runat="server"></asp:Literal>
                                        </span></div>
                                    <span class="val-cust-phone" style="display:none;">
                                        <asp:Literal ID="litDetailCustPhone" runat="server"></asp:Literal>
                                    </span>
                                    <asp:HyperLink ID="lnkCallCust" runat="server" CssClass="btn-call-cust">
                                    </asp:HyperLink>
                                </div>
                            </div>
                        </div>

                        <div>
                            <div class="info-box-title"><i class="fas fa-location-dot"></i> Delivery Address & Payment
                            </div>
                            <div style="font-size:13px; color:#334155; line-height:1.4;">
                                <strong>Address:</strong> <span class="val-address">
                                    <asp:Literal ID="litDetailAddress" runat="server"></asp:Literal>
                                </span><br />
                                <strong>Payment:</strong> <span class="val-payment">
                                    <asp:Literal ID="litDetailPayment" runat="server"></asp:Literal>
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- ACTION CONTROLS PANEL (PLACED AT TOP FOR EASY ACCESS) -->
                    <div class="detail-actions-panel">
                        <div class="info-box-title"><i class="fas fa-sliders"></i> Kitchen Workflow Actions</div>

                        <!-- ACTION PANEL FOR PREPARING -->
                        <asp:Panel ID="pnlDispatchAction" runat="server" Visible="false">
                            <div style="background: #f0f9ff; border: 1px solid #bae6fd; border-radius: 8px; padding: 10px 14px; margin-bottom: 12px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 8px;">
                                <div style="color: #0369a1; font-weight: 700; font-size: 13px; display: flex; align-items: center; gap: 8px;">
                                    <span>🛵 Looking for nearby drivers for pickup...</span>
                                </div>
                                <span style="background: #e0f2fe; color: #0369a1; font-size: 11px; font-weight: 700; padding: 2px 8px; border-radius: 6px; border: 1px solid #7dd3fc;">⚡ Auto-Dispatch</span>
                            </div>
                            <div style="display:flex; flex-direction:column; gap:8px; margin-bottom: 8px;">
                                <label style="font-size:13px; font-weight:700; color:#334155;">Or Manually Assign Available Driver:</label>
                                <div style="display:flex; gap:10px; flex-wrap:wrap;">
                                    <asp:DropDownList ID="ddlDetailDriver" runat="server" CssClass="styled-dropdown"
                                        style="max-width:320px;"></asp:DropDownList>
                                </div>
                            </div>
                        </asp:Panel>

                        <!-- ACTION PANEL FOR DISPATCHED -->
                        <asp:Panel ID="pnlDispatchedDriverBadge" runat="server" Visible="false">
                            <div
                                style="background:#eff6ff; border:1px solid #bfdbfe; border-radius:10px; padding:12px 16px; margin-bottom:10px; display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:10px;">
                                <div>
                                    <i class="fas fa-motorcycle"
                                        style="color:#2563eb; font-size:16px; margin-right:6px;"></i>
                                    <strong>Driver:</strong> <span class="val-driver-name">
                                        <asp:Literal ID="litDetailDriverName" runat="server"></asp:Literal>
                                    </span>
                                    (<asp:Literal ID="litDetailDriverVehicle" runat="server"></asp:Literal>) -
                                    <asp:Literal ID="litDetailDriverPhone" runat="server" Visible="false"></asp:Literal>
                                    <asp:HyperLink ID="lnkCallDriver" runat="server"
                                        style="color:#2563eb; font-weight:700;"></asp:HyperLink>
                                </div>
                                <div
                                    style="background:#fef3c7; border:1px solid #fde68a; color:#92400e; padding:6px 14px; border-radius:8px; font-size:13px; font-weight:800; display:inline-flex; align-items:center; gap:6px;">
                                    <i class="fas fa-key" style="color:#d97706;"></i> Delivery OTP: <span
                                        style="font-size:16px; color:#d97706; background:#fff; padding:2px 8px; border-radius:4px;"><span
                                            class="val-driver-otp">
                                            <asp:Literal ID="litDetailOtp" runat="server"></asp:Literal>
                                        </span></span>
                                </div>
                            </div>
                        </asp:Panel>

                        <!-- ACTION PANEL FOR COMPLETED -->
                        <asp:Panel ID="pnlCompletedAction" runat="server" Visible="false">
                            <div
                                style="background:#f0fdf4; border:1px solid #bbf7d0; color:#15803d; border-radius:10px; padding:12px 16px; margin-bottom:10px; font-size:13px; font-weight:700; display:flex; align-items:center; gap:8px;">
                                <i class="fas fa-circle-check" style="font-size:16px;"></i> Order Delivered Successfully
                                on <asp:Literal ID="litDetailDeliveredTime" runat="server"></asp:Literal>
                            </div>
                        </asp:Panel>

                        <!-- SINGLE RESPONSIVE SIDE-BY-SIDE FLEX BUTTON BAR -->
                        <div class="workflow-actions-bar">
                            <asp:Button ID="btnDetailAccept" runat="server" Text="Accept & Start Cooking"
                                CssClass="btn-action-main btn-accept-main" OnClick="btnDetailAccept_Click" Visible="false" />
                            <asp:Button ID="btnDetailDispatch" runat="server" Text="Dispatch Order"
                                CssClass="btn-action-main btn-dispatch-main" OnClick="btnDetailDispatch_Click" Visible="false" />
                            <asp:Button ID="btnDetailComplete" runat="server" Text="Mark Delivered"
                                CssClass="btn-action-main btn-complete-main" OnClick="btnDetailComplete_Click" Visible="false" />
                            <asp:Button ID="btnDetailCancel" runat="server" Text="Cancel Order"
                                CssClass="btn-action-main btn-cancel-main" OnClick="btnDetailCancel_Click" Visible="false" />
                            <button type="button" class="btn-action-main btn-print-main"
                                onclick="printThermalInvoice();">
                                <i class="fas fa-print"></i> Print Receipt
                            </button>
                        </div>

                    </div>

                    <!-- ITEMIZED RECEIPT TABLE -->
                    <div class="receipt-card">
                        <table class="receipt-table">
                            <thead>
                                <tr>
                                    <th>Food Dish Item</th>
                                    <th style="text-align:center;">Qty</th>
                                    <th style="text-align:right;">Unit Price</th>
                                    <th style="text-align:right;">Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptDetailItems" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td><strong>
                                                    <%# Eval("item_name") %>
                                                </strong></td>
                                            <td style="text-align:center;"><span
                                                    style="background:#f1f5f9; padding:2px 8px; border-radius:12px; font-weight:800;">
                                                    <%# Eval("quantity") %>x
                                                </span></td>
                                            <td style="text-align:right;">₹<%# Eval("price", "{0:N2}" ) %>
                                            </td>
                                            <td style="text-align:right; font-weight:700;">₹<%#
                                                    Convert.ToDecimal(Eval("price")) * Convert.ToInt32(Eval("quantity"))
                                                    %>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                        <div class="receipt-summary-box">
                            <div class="summary-row grand-total">
                                <span>Total Amount:</span>
                                <span class="amount"><span class="val-grandtotal">
                                        <asp:Literal ID="litDetailGrandTotal" runat="server">₹0.00</asp:Literal>
                                    </span></span>
                            </div>
                            <div style="font-size: 11px; color: #64748b; font-weight: 600; text-align: right; margin-top: 2px;">(Incl. of all taxes & GST)</div>
                        </div>
                    </div>

                </asp:Panel>

                <asp:Panel ID="pnlNoSelectedOrder" runat="server" CssClass="detail-pane" Visible="false"
                    style="display:flex; align-items:center; justify-content:center; text-align:center; color:#94a3b8;">
                    <div>
                        <i class="fas fa-hand-pointer" style="font-size:3rem; margin-bottom:12px;"></i>
                        <h3>Select an Order from the left queue to view details</h3>
                    </div>
                </asp:Panel>

            </div>

            <!-- PAGINATION CONTROLS -->
            <div class="pagination" style="display:flex; justify-content:center; gap:8px; margin-top:20px;">
                <asp:LinkButton ID="lnkFirst" runat="server" CssClass="page-item" OnClick="lnkFirst_Click"><img
                        src="../icons/a1.png" alt="First" width="20" /></asp:LinkButton>
                <asp:LinkButton ID="lnkPrevious" runat="server" CssClass="page-item" OnClick="lnkPrevious_Click"><img
                        src="../icons/a2.png" alt="Prev" width="20" /></asp:LinkButton>
                <asp:Repeater ID="rptPagination" runat="server" OnItemCommand="rptPagination_ItemCommand">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkPage" runat="server"
                            CssClass='<%# IIf(Convert.ToBoolean(Eval("IsActive")), "page-item active", "page-item") %>'
                            CommandName="Page" CommandArgument='<%# Eval("PageNumber") %>'>
                            <%# Eval("PageNumber") %>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:LinkButton ID="lnkNext" runat="server" CssClass="page-item" OnClick="lnkNext_Click"><img
                        src="../icons/a3.png" alt="Next" width="20" /></asp:LinkButton>
                <asp:LinkButton ID="lnkLast" runat="server" CssClass="page-item" OnClick="lnkLast_Click"><img
                        src="../icons/a4.png" alt="Last" width="20" /></asp:LinkButton>
            </div>

        </div>
    </asp:Content>