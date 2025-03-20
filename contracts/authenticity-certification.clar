;; Authenticity Certification Contract
;; Issues verifiable credentials for handmade items

(define-map craft-items
  { id: uint }
  {
    name: (string-utf8 100),
    craftsperson-id: uint,
    techniques-used: (list 10 uint),
    materials-used: (list 10 uint),
    creation-date: uint,
    certified: bool
  }
)

(define-map certificates
  { item-id: uint }
  {
    certificate-id: (string-utf8 100),
    issue-date: uint,
    issuer: principal,
    valid-until: uint
  }
)

(define-data-var last-item-id uint u0)

(define-public (register-craft-item
    (name (string-utf8 100))
    (craftsperson-id uint)
    (techniques-used (list 10 uint))
    (materials-used (list 10 uint)))
  (let
    (
      (new-id (+ (var-get last-item-id) u1))
    )
    (var-set last-item-id new-id)
    (ok (map-set craft-items
      { id: new-id }
      {
        name: name,
        craftsperson-id: craftsperson-id,
        techniques-used: techniques-used,
        materials-used: materials-used,
        creation-date: block-height,
        certified: false
      }
    ))
  )
)

(define-public (certify-item (item-id uint) (certificate-id (string-utf8 100)) (valid-years uint))
  (let
    (
      (item (unwrap! (map-get? craft-items { id: item-id }) (err u404)))
      (valid-until (+ block-height (* valid-years u144))) ;; Assuming ~144 blocks per day * 365 days
    )
    (map-set craft-items
      { id: item-id }
      (merge item { certified: true })
    )
    (ok (map-set certificates
      { item-id: item-id }
      {
        certificate-id: certificate-id,
        issue-date: block-height,
        issuer: tx-sender,
        valid-until: valid-until
      }
    ))
  )
)

(define-read-only (get-craft-item (id uint))
  (map-get? craft-items { id: id })
)

(define-read-only (get-certificate (item-id uint))
  (map-get? certificates { item-id: item-id })
)

(define-read-only (verify-certificate (item-id uint))
  (let
    (
      (certificate (unwrap! (map-get? certificates { item-id: item-id }) (err u404)))
    )
    (ok (< block-height (get valid-until certificate)))
  )
)
