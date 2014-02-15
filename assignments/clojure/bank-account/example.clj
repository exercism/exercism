(ns bank)

(defn open-account []
  (ref 0))

(defn close-account [account]
  (dosync
    (ref-set account nil)))

(defn get-balance [account]
  (dosync
    @account))

(defn update-balance [account amt]
  (dosync
    (alter account + amt)))

