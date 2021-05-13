--パーティカル・フュージョン
function c39261576.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		filter=aux.FilterBoolFunction(Card.IsSetCard,0x1047),
		mat_location=LOCATION_MZONE,
		foperation=c39261576.fop
	})
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetDescription(aux.Stringid(39261576,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CUSTOM+39261576)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c39261576.atkcon)
	e2:SetCost(c39261576.atkcost)
	e2:SetTarget(c39261576.atktg)
	e2:SetOperation(c39261576.atkop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c39261576.fop(e,tp,tc)
	e:SetLabelObject(tc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetOperation(c39261576.evop)
	e1:SetLabelObject(e)
	Duel.RegisterEffect(e1,tp)
end
function c39261576.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function c39261576.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c39261576.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=eg:GetFirst()
	local mat=tc:GetMaterial()
	if chkc then return chkc:IsSetCard(0x1047) and mat:IsContains(chkc) end
	if chk==0 then return mat:IsExists(Card.IsSetCard,1,nil,0x1047) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(39261576,1))
	local g=mat:FilterSelect(tp,Card.IsSetCard,1,1,nil,0x1047)
	tc:CreateEffectRelation(e)
	Duel.SetTargetCard(g)
end
function c39261576.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local sc=eg:GetFirst()
	if not sc:IsRelateToEffect(e) or sc:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(tc:GetAttack())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	sc:RegisterEffect(e1)
end
function c39261576.evop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetLabelObject()
	Duel.RaiseEvent(tc,EVENT_CUSTOM+39261576,te,0,tp,tp,0)
	te:SetLabelObject(nil)
	e:Reset()
end
