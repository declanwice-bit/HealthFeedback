;; FeedbackToken.clar
;; SIP-010 compliant fungible token for HealthFeedback (HFB)
;; This token incentivizes patient feedback, rewards contributions,
;; and is used for staking in submissions and governance.

;; Traits
(use-trait ft-trait .sip-010-trait.sip-010-trait)

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-PAUSED (err u101))
(define-constant ERR-INVALID-AMOUNT (err u102))
(define-constant ERR-INVALID-RECIPIENT (err u103))
(define-constant ERR-INVALID-MINTER (err u104))
(define-constant ERR-ALREADY-REGISTERED (err u105))
(define-constant ERR-METADATA-TOO-LONG (err u106))
(define-constant ERR-INSUFFICIENT-BALANCE (err u107))
(define-constant ERR-TRANSFER-FAILED (err u108))
(define-constant ERR-BURN-FAILED (err u109))
(define-constant ERR-MINT-FAILED (err u110))
(define-constant MAX-METADATA-LEN u500)

;; Data Variables
(define-data-var total-supply uint u0)
(define-data-var paused bool false)
(define-data-var admin principal tx-sender)

;; Data Maps
(define-map balances principal uint)
(define-map minters principal bool)
(define-map mint-records uint {amount: uint, recipient: principal, metadata: (string-utf8 500), timestamp: uint})
(define-data-var mint-counter uint u0)

;; SIP-010 Functions

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (asserts! (not (var-get paused)) ERR-PAUSED)
    (asserts! (is-eq tx-sender sender) ERR-NOT-AUTHORIZED)
    (asserts! (> amount u0) ERR-INVALID-AMOUNT)
    (asserts! (not (is-eq recipient CONTRACT-OWNER)) ERR-INVALID-RECIPIENT) ;; Prevent transfer to contract owner as sink
    (try! (ft-transfer? hfb-token amount sender recipient))
    (ok true)
  )
)

(define-read-only (get-name)
  (ok "HealthFeedbackToken")
)

(define-read-only (get-symbol)
  (ok "HFB")
)

(define-read-only (get-decimals)
  (ok u6)
)

(define-read-only (get-balance (account principal))
  (ok (ft-get-balance hfb-token account))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply hfb-token))
)

(define-read-only (get-token-uri)
  (ok (some "https://healthfeedback.xyz/token-metadata.json"))
)

;; Admin Functions

(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) ERR-NOT-AUTHORIZED)
    (var-set admin new-admin)
    (ok true)
  )
)

(define-public (pause-contract)
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) ERR-NOT-AUTHORIZED)
    (var-set paused true)
    (ok true)
  )
)

(define-public (unpause-contract)
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) ERR-NOT-AUTHORIZED)
    (var-set paused false)
    (ok true)
  )
)

(define-public (add-minter (minter principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) ERR-NOT-AUTHORIZED)
    (asserts! (is-none (map-get? minters minter)) ERR-ALREADY-REGISTERED)
    (map-set minters minter true)
    (ok true)
  )
)

(define-public (remove-minter (minter principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) ERR-NOT-AUTHORIZED)
    (map-set minters minter false)
    (ok true)
  )
)

;; Minting Functions

(define-public (mint (amount uint) (recipient principal) (metadata (string-utf8 500)))
  (let
    (
      (current-balance (ft-get-balance hfb-token recipient))
    )
    (asserts! (not (var-get paused)) ERR-PAUSED)
    (asserts! (default-to false (map-get? minters tx-sender)) ERR-INVALID-MINTER)
    (asserts! (> amount u0) ERR-INVALID-AMOUNT)
    (asserts! (not (is-eq recipient CONTRACT-OWNER)) ERR-INVALID-RECIPIENT)
    (asserts! (<= (len metadata) MAX-METADATA-LEN) ERR-METADATA-TOO-LONG)
    (try! (ft-mint? hfb-token amount recipient))
    (let
      (
        (token-id (+ (var-get mint-counter) u1))
      )
      (map-set mint-records token-id {amount: amount, recipient: recipient, metadata: metadata, timestamp: block-height})
      (var-set mint-counter token-id)
    )
    (ok true)
  )
)

;; Burning Functions

(define-public (burn (amount uint))
  (begin
    (asserts! (not (var-get paused)) ERR-PAUSED)
    (asserts! (> amount u0) ERR-INVALID-AMOUNT)
    (asserts! (>= (ft-get-balance hfb-token tx-sender) amount) ERR-INSUFFICIENT-BALANCE)
    (try! (ft-burn? hfb-token amount tx-sender))
    (ok true)
  )
)

;; Read-only Functions

(define-read-only (is-minter (account principal))
  (default-to false (map-get? minters account))
)

(define-read-only (is-paused)
  (var-get paused)
)

(define-read-only (get-mint-record (token-id uint))
  (map-get? mint-records token-id)
)

;; Internal Functions

(define-private (ft-transfer? (token <ft-trait>) (amount uint) (sender principal) (recipient principal))
  (begin
    (asserts! (>= (unwrap-panic (contract-call? token get-balance sender)) amount) ERR-INSUFFICIENT-BALANCE)
    (try! (as-contract (contract-call? token transfer amount sender recipient none)))
    (ok true)
  )
)

(define-private (ft-mint? (token <ft-trait>) (amount uint) (recipient principal))
  (begin
    (try! (as-contract (contract-call? token mint amount recipient)))
    (ok true)
  )
)

(define-private (ft-burn? (token <ft-trait>) (amount uint) (sender principal))
  (begin
    (try! (as-contract (contract-call? token burn amount sender)))
    (ok true)
  )
)

;; Token Definition
(define-fungible-token hfb-token u1000000000000) ;; Max supply 1 trillion with 6 decimals

;; Initial Setup
(begin
  ;; Mint initial supply to contract owner or treasury
  (ft-mint? hfb-token u1000000000000 CONTRACT-OWNER)
)