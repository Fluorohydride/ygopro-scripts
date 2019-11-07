--クロシープ
function c50277355.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c50277355.lcheck)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,50277355)
	e1:SetCondition(c50277355.condition)
	e1:SetTarget(c50277355.target)
	e1:SetOperation(c50277355.activate)
	c:RegisterEffect(e1)
end
function c50277355.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function c50277355.cfilter(c,lg)
	return lg:IsContains(c)
end
function c50277355.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50277355.condition(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c50277355.cfilter,1,nil,lg)
end
function c50277355.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	local b1=Duel.IsPlayerCanDraw(tp,2) and lg:IsExists(Card.IsType,1,nil,TYPE_RITUAL)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c50277355.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and lg:IsExists(Card.IsType,1,nil,TYPE_FUSION)
	local b3=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and lg:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO)
	local b4=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and lg:IsExists(Card.IsType,1,nil,TYPE_XYZ)
	if chk==0 then return b1 or b2 or b3 or b4 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c50277355.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local lg=e:GetHandler():GetLinkedGroup()
	local b1=Duel.IsPlayerCanDraw(tp,2) and lg:IsExists(Card.IsType,1,nil,TYPE_RITUAL)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c50277355.spfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp) and lg:IsExists(Card.IsType,1,nil,TYPE_FUSION)
	local b3=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and lg:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO)
	local b4=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and lg:IsExists(Card.IsType,1,nil,TYPE_XYZ)
	local res=0
	if b1 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		res=Duel.Draw(p,d,REASON_EFFECT)
		if res==2 then
			Duel.ShuffleHand(p)
			Duel.BreakEffect()
			local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
			local sg=g:Select(p,2,2,nil)
			Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
		end
	end
	if b2 then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c50277355.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		res=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	if b3 then
		if res~=0 then Duel.BreakEffect() end
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(700)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			res=res+1
			tc=g:GetNext()
		end
	end
	if b4 then
		if res~=0 then Duel.BreakEffect() end
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-700)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end
