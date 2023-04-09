--ハイパー・シンクロン
function c40348946.initial_effect(c)
	--atk change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40348946,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCondition(c40348946.con)
	e1:SetTarget(c40348946.tg)
	e1:SetOperation(c40348946.op)
	c:RegisterEffect(e1)
	aux.CreateMaterialReasonCardRelation(c,e1)
end
function c40348946.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO and c:GetReasonCard():IsRace(RACE_DRAGON)
end
function c40348946.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=e:GetHandler():GetReasonCard()
	if chk==0 then return rc:IsRelateToEffect(e) and rc:IsFaceup() end
	Duel.SetTargetCard(rc)
end
function c40348946.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sync=Duel.GetFirstTarget()
	if not sync:IsRelateToChain() or sync:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(800)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	sync:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetOperation(c40348946.rmop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	sync:RegisterEffect(e2)
end
function c40348946.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
