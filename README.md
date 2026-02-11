# 📌 VirusTotal IP Reputation Checker (Batch Scanner)

Simple Bash script untuk mengecek reputasi IP address menggunakan **VirusTotal API v3**.

Script ini membaca daftar IP dari file, melakukan request ke VirusTotal, lalu menghasilkan output CSV berisi:

* Country
* Organization / ASN Owner
* Total deteksi malicious + suspicious
* Vendor sources yang menandai IP sebagai malicious/suspicious

---

## 🚀 Features

✅ Batch scan multiple IPs
✅ Output CSV siap untuk reporting
✅ Deteksi total malicious + suspicious
✅ List vendor sources yang flag IP
✅ API key disimpan aman di file terpisah (`apikey.txt`)

---

## 📂 Project Structure

```
virustotal-ip-checker/
│
├── vt_ip_check.sh        # Main script
├── listipcek.txt         # Input list of IP addresses
├── apikey.txt            # VirusTotal API key
└── vt_ip_output.csv      # Output result (generated)
```

---

## 🔑 Requirements

Script membutuhkan:

* Linux / macOS Bash shell
* `curl`
* `jq` (untuk parsing JSON response)

Install jq:

### Debian/Ubuntu

```bash
sudo apt update
sudo apt install jq -y
```

### MacOS (Homebrew)

```bash
brew install jq
```

---

## ⚙️ Setup

### 1. Clone Repository

```bash
git clone https://github.com/yourusername/virustotal-ip-checker.git
cd virustotal-ip-checker
```

---

### 2. Add Your VirusTotal API Key

Buat file `apikey.txt`:

```bash
echo "YOUR_API_KEY_HERE" > apikey.txt
```

⚠️ Jangan pernah upload API key ke GitHub publik.

Tambahkan ke `.gitignore`:

```
apikey.txt
```

---

### 3. Add IP List

Edit file `listipcek.txt`:

```txt
91.132.144.59
8.8.8.8
1.1.1.1
```

Satu IP per baris.

---

## ▶️ Usage

Jalankan script:

```bash
bash vt_ip_check.sh
```

---

## 📊 Output

Script akan menghasilkan file:

```
vt_ip_output.csv
```

Format output:

```
IP;country;organization;total malicious/suspicious;Source malicious/suspicious
91.132.144.59;DE;netcup GmbH;12;ADMINUSLabs,Criminal IP,GreyNoise
```

### Field Explanation

| Column                      | Description                                    |
| --------------------------- | ---------------------------------------------- |
| IP                          | Target IP address                              |
| country                     | Country code dari VirusTotal                   |
| organization                | ASN owner / network organization               |
| total malicious/suspicious  | Jumlah engine yang flag malicious + suspicious |
| Source malicious/suspicious | Vendor names yang mendeteksi IP                |

---

## ⚠️ Notes

* VirusTotal API punya rate limit tergantung plan akun.
* Kalau scanning banyak IP, disarankan menambahkan delay:

```bash
sleep 2
```

di dalam loop.

---

## 🛠 Future Improvements (Optional)

* Support retry jika kena HTTP 429 (quota exceeded)
* Parallel scanning mode
* Tambahan ASN, netname, tags
* Export JSON report

---

## 📜 License

MIT License — bebas dipakai untuk kebutuhan security research dan internal monitoring.

---

