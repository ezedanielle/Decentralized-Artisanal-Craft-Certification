;; Technique Verification Contract
;; Validates traditional methods and skills

(define-map techniques
  { id: uint }
  {
    name: (string-utf8 100),
    description: (string-utf8 500),
    region-of-origin: (string-utf8 100),
    verified: bool
  }
)

(define-map craftsperson-techniques
  { craftsperson-id: uint, technique-id: uint }
  {
    verification-date: uint,
    verified-by: principal,
    skill-level: (string-utf8 50)
  }
)

(define-data-var last-technique-id uint u0)

(define-public (register-technique (name (string-utf8 100)) (description (string-utf8 500)) (region (string-utf8 100)))
  (let
    (
      (new-id (+ (var-get last-technique-id) u1))
    )
    (var-set last-technique-id new-id)
    (ok (map-set techniques
      { id: new-id }
      {
        name: name,
        description: description,
        region-of-origin: region,
        verified: false
      }
    ))
  )
)

(define-public (verify-technique (technique-id uint))
  (let
    (
      (technique (unwrap! (map-get? techniques { id: technique-id }) (err u404)))
    )
    (ok (map-set techniques
      { id: technique-id }
      (merge technique { verified: true })
    ))
  )
)

(define-public (assign-technique-to-craftsperson (craftsperson-id uint) (technique-id uint) (skill-level (string-utf8 50)))
  (ok (map-set craftsperson-techniques
    { craftsperson-id: craftsperson-id, technique-id: technique-id }
    {
      verification-date: block-height,
      verified-by: tx-sender,
      skill-level: skill-level
    }
  ))
)

(define-read-only (get-technique (id uint))
  (map-get? techniques { id: id })
)

(define-read-only (get-craftsperson-technique (craftsperson-id uint) (technique-id uint))
  (map-get? craftsperson-techniques { craftsperson-id: craftsperson-id, technique-id: technique-id })
)
