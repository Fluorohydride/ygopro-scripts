--7
function c67048711.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c67048711.target)
	e1:SetOperation(c67048711.operation)
	c:RegisterEffect(e1)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67048711,1))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c67048711.reccon)
	e3:SetTarget(c67048711.rectg)
	e3:SetOperation(c67048711.recop)
	c:RegisterEffect(e3)
end
function c67048711.filter(c)
	return c:IsFaceup() and c:IsCode(67048711)
end
function c67048711.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetMatchingGroupCount(c67048711.filter,tp,LOCATION_SZONE,0,nil)==3 then
		local g=Duel.GetMatchingGroup(c67048711.filter,tp,LOCATION_ONFIELD,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
end
function c67048711.operation(e,tp,eg,ep,ev,re,r,rp)
	local ex=Duel.GetOperationInfo(0,CATEGORY_DRAW)
	if ex then
		if Duel.Draw(tp,3,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(c67048711.filter,tp,LOCATION_ONFIELD,0,nil)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c67048711.reccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c67048711.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(700)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,700)
end
function c67048711.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
