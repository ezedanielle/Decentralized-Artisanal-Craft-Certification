;; Craftsperson Registration Contract
;; Records details of skilled artisans

(define-data-var last-id uint u0)

(define-map craftspeople
  { id: uint }
  {
    name: (string-utf8 100),
    location: (string-utf8 100),
    specialty: (string-utf8 100),
    registration-date: uint,
    active: bool
  }
)

(define-public (register-craftsperson (name (string-utf8 100)) (location (string-utf8 100)) (specialty (string-utf8 100)))
  (let
    (
      (new-id (+ (var-get last-id) u1))
    )
    (var-set last-id new-id)
    (ok (map-set craftspeople
      { id: new-id }
      {
        name: name,
        location: location,
        specialty: specialty,
        registration-date: block-height,
        active: true
      }
    ))
  )
)

(define-read-only (get-craftsperson (id uint))
  (map-get? craftspeople { id: id })
)

(define-public (update-craftsperson-status (id uint) (active bool))
  (let
    (
      (craftsperson (unwrap! (map-get? craftspeople { id: id }) (err u404)))
    )
    (ok (map-set craftspeople
      { id: id }
      (merge craftsperson { active: active })
    ))
  )
)
