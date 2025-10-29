<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Invoice</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .suggestion {
            cursor: pointer;
            padding: 6px;
        }
        .suggestion:hover { background: #f1f1f1; }
        .suggestions-box {
            border: 1px solid #ddd;
            max-height: 200px;
            overflow: auto;
            background: white;
            position: absolute;
            z-index: 1000;
            width: 100%;
        }
    </style>
</head>
<body class="container mt-4">

    <!-- Header with both Back buttons -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Add Invoice</h2>
        <div>
            <a href="/" class="btn btn-secondary me-2">← Back to Dashboard</a>

        </div>
    </div>

    <div class="card p-3">
        <form action="/add-invoice" method="post" class="row g-3">

            <!-- Patient search / dropdown -->
            <div class="col-md-12 position-relative">
                <label class="form-label">Select Patient</label>
                <input id="patientSearch" type="text" class="form-control" placeholder="Type patient name..." autocomplete="off" required>
                <div id="suggestions" class="suggestions-box" style="display:none;"></div>

                <input type="hidden" name="patientId" id="patientId">
                <input type="hidden" name="patientName" id="patientName">
            </div>

            <div class="col-md-12">
                <label class="form-label">Or pick from list</label>
                <select id="patientSelect" class="form-select" onchange="selectFromDropdown()">
                    <option value="">-- choose patient --</option>
                    <#list patients as p>
                        <option value="${p.id}">${p.fullName} (${p.id})</option>
                    </#list>
                </select>
            </div>

            <div class="col-md-6">
                <label class="form-label">Amount</label>
                <input type="number" step="0.01" name="amount" class="form-control" required>
            </div>

            <div class="col-md-6">
                <label class="form-label">Payment Method</label>
                <select name="paymentMethod" class="form-select" required>
                    <#list paymentMethods as pm>
                        <option value="${pm}">${pm}</option>
                    </#list>
                </select>
            </div>

            <div class="col-12">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control" rows="3"></textarea>
            </div>

            <div class="col-md-6">
                <label class="form-label">Invoice Date</label>
                <input type="date" name="invoiceDate" class="form-control" value="${.now?string('yyyy-MM-dd')}">
            </div>

            <div class="col-12 mt-3">
                <button type="submit" class="btn btn-success">Create Invoice</button>
                <a href="/billing" class="btn btn-secondary me-2">Cancel</a>

            </div>

        </form>
    </div>

    <script>
        const patients = [
            <#list patients as p>
                { id: ${p.id}, name: "${p.fullName?js_string}" }<#if p_has_next>,</#if>
            </#list>
        ];

        const input = document.getElementById('patientSearch');
        const suggestionsBox = document.getElementById('suggestions');
        const patientIdField = document.getElementById('patientId');
        const patientNameField = document.getElementById('patientName');
        const select = document.getElementById('patientSelect');

        input.addEventListener('input', function() {
            const q = this.value.trim().toLowerCase();
            if (!q) { suggestionsBox.style.display = 'none'; return; }
            const matches = patients.filter(p => p.name.toLowerCase().includes(q));
            if (matches.length === 0) { suggestionsBox.style.display = 'none'; return; }

            suggestionsBox.innerHTML = '';
            matches.forEach(m => {
                const div = document.createElement('div');
                div.className = 'suggestion';
                div.innerText = m.name + ' (ID ' + m.id + ')';
                div.dataset.id = m.id;
                div.dataset.name = m.name;
                div.onclick = () => patientSelected(m.id, m.name);
                suggestionsBox.appendChild(div);
            });
            suggestionsBox.style.display = 'block';
        });

        document.addEventListener('click', (e) => {
            if (!input.contains(e.target) && !suggestionsBox.contains(e.target)) {
                suggestionsBox.style.display = 'none';
            }
        });

        function patientSelected(id, name) {
            input.value = name;
            patientIdField.value = id;
            patientNameField.value = name;
            suggestionsBox.style.display = 'none';
            const opt = Array.from(select.options).find(o => o.value == id);
            if (opt) select.value = id;
        }

        function selectFromDropdown() {
            const v = select.value;
            if (!v) {
                patientIdField.value = '';
                patientNameField.value = '';
                input.value = '';
                return;
            }
            const opt = select.options[select.selectedIndex];
            const name = opt.text.replace(/\s*\(\s*ID.*\)$/, '').trim();
            patientIdField.value = v;
            patientNameField.value = name;
            input.value = name;
        }
    </script>
</body>
</html>
