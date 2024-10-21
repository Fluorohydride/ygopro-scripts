--大金星！？
function c84677654.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c84677654.target)
	e1:SetOperation(c84677654.operation)
	c:RegisterEffect(e1)
end
c84677654.toss_coin=true
function c84677654.cfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(0)
end
function c84677654.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c84677654.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
	local lv=Duel.AnnounceLevel(tp)
	Duel.SetTargetParam(lv)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,PLAYER_ALL,2)
end
function c84677654.operation(e,tp,eg,ep,ev,re,r,rp)
	local lv=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local coin1=Duel.TossCoin(tp,1)
	local coin2=Duel.TossCoin(1-tp,1)
	if coin1==1 and coin2==1 then
		local g=Duel.GetMatchingGroup(c84677654.cfilter,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	elseif coin1==0 and coin2==0 then
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,lp-lv*500)
	end
end
