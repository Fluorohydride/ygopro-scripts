--化合電界
function c65959844.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65959844,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCountLimit(1)
	e2:SetCondition(c65959844.ntcon)
	e2:SetTarget(c65959844.nttg)
	c:RegisterEffect(e2)
	--extra summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_DUAL))
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(65959844,1))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c65959844.destg)
	e4:SetOperation(c65959844.desop)
	c:RegisterEffect(e4)
end
function c65959844.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c65959844.nttg(e,c)
	return c:IsLevelAbove(5) and c:IsType(TYPE_DUAL)
end
function c65959844.rmfilter(c)
	return c:IsDualState() and c:IsAbleToRemove()
end
function c65959844.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c65959844.rmfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c65959844.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c65959844.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local rc=g:GetFirst()
	if rc and Duel.Remove(rc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and rc:IsLocation(LOCATION_REMOVED) then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
		rc:RegisterFlagEffect(65959844,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(rc)
		e1:SetCondition(c65959844.retcon)
		e1:SetOperation(c65959844.retop)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
	end
end
function c65959844.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and e:GetLabelObject():GetFlagEffect(65959844)~=0
end
function c65959844.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
end
