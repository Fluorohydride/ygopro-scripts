--メンタル・カウンセラー リリー
---@param c Card
function c5519829.initial_effect(c)
	--atk change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5519829,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCondition(c5519829.con)
	e1:SetCost(c5519829.cost)
	e1:SetTarget(c5519829.tg)
	e1:SetOperation(c5519829.op)
	c:RegisterEffect(e1)
	aux.CreateMaterialReasonCardRelation(c,e1)
end
function c5519829.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c5519829.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c5519829.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=e:GetHandler():GetReasonCard()
	if chk==0 then return rc:IsRelateToEffect(e) and rc:IsFaceup() end
	Duel.SetTargetCard(rc)
end
function c5519829.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sync=Duel.GetFirstTarget()
	if not sync:IsRelateToChain() or sync:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	sync:RegisterEffect(e1)
end
