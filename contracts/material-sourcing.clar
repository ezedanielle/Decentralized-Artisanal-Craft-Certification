;; Material Sourcing Contract
;; Tracks origin of raw materials used

(define-map materials
  { id: uint }
  {
    name: (string-utf8 100),
    source-location: (string-utf8 100),
    sustainable: bool,
    description: (string-utf8 500)
  }
)

(define-map material-batches
  { batch-id: uint }
  {
    material-id: uint,
    quantity: uint,
    harvest-date: uint,
    supplier: principal
  }
)

(define-data-var last-material-id uint u0)
(define-data-var last-batch-id uint u0)

(define-public (register-material (name (string-utf8 100)) (source (string-utf8 100)) (sustainable bool) (description (string-utf8 500)))
  (let
    (
      (new-id (+ (var-get last-material-id) u1))
    )
    (var-set last-material-id new-id)
    (ok (map-set materials
      { id: new-id }
      {
        name: name,
        source-location: source,
        sustainable: sustainable,
        description: description
      }
    ))
  )
)

(define-public (register-material-batch (material-id uint) (quantity uint) (harvest-date uint))
  (let
    (
      (new-id (+ (var-get last-batch-id) u1))
    )
    (var-set last-batch-id new-id)
    (ok (map-set material-batches
      { batch-id: new-id }
      {
        material-id: material-id,
        quantity: quantity,
        harvest-date: harvest-date,
        supplier: tx-sender
      }
    ))
  )
)

(define-read-only (get-material (id uint))
  (map-get? materials { id: id })
)

(define-read-only (get-material-batch (batch-id uint))
  (map-get? material-batches { batch-id: batch-id })
)
