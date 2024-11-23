--冥王竜ヴァンダルギオン
---@param c Card
function c24857466.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetRange(LOCATION_HAND)
	e2:SetOperation(c24857466.chop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(24857466,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c24857466.hspcon)
	e3:SetTarget(c24857466.hsptg)
	e3:SetOperation(c24857466.hspop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(24857466,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_CUSTOM+24857466)
	e4:SetTarget(c24857466.target)
	e4:SetOperation(c24857466.operation)
	c:RegisterEffect(e4)
end
function c24857466.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==tp then return end
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	if de and dp==tp and de:GetHandler():IsType(TYPE_COUNTER) then
		local ty=re:GetActiveType()
		local flag=c:GetFlagEffectLabel(24857466)
		if not flag then
			c:RegisterFlagEffect(24857466,RESET_EVENT+RESETS_STANDARD,0,0,ty)
			e:SetLabelObject(de)
		elseif de~=e:GetLabelObject() then
			e:SetLabelObject(de)
			c:SetFlagEffectLabel(24857466,ty)
		else
			c:SetFlagEffectLabel(24857466,flag|ty)
		end
	end
end
function c24857466.hspcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local label=c:GetFlagEffectLabel(24857466)
	if label~=nil and label~=0 then
		e:SetLabel(label)
		c:SetFlagEffectLabel(24857466,0)
		return true
	else return false end
end
function c24857466.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c24857466.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tpe=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+24857466,e,0,0,tp,tpe)
	end
end
function c24857466.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
---dynamic target
function c24857466.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if ev==TYPE_TRAP then
			return chkc:IsControler(1-tp) and chkc:IsOnField()
		elseif ev==TYPE_MONSTER then
			return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c24857466.spfilter(chkc,e,tp)
		else
			return false
		end
	end
	if chk==0 then return true end
	local cat=0
	local prop=0
	if ev&TYPE_SPELL~=0 then
		cat=cat|CATEGORY_DAMAGE
		prop=prop|EFFECT_FLAG_PLAYER_TARGET
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(1500)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1500)
	end
	if ev&TYPE_TRAP~=0 then
		cat=cat|CATEGORY_DESTROY
		prop=prop|EFFECT_FLAG_CARD_TARGET
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g1=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
		end
	end
	if ev&TYPE_MONSTER~=0 then
		cat=cat|CATEGORY_SPECIAL_SUMMON
		prop=prop|EFFECT_FLAG_CARD_TARGET
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectTarget(tp,c24857466.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g2:GetCount()>0 then
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
		end
	end
	e:SetCategory(cat)
	e:SetProperty(prop)
	e:SetLabel(ev)
end
function c24857466.operation(e,tp,eg,ep,ev,re,r,rp)
	local typ=e:GetLabel()
	local res=0
	if typ&TYPE_SPELL~=0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		res=Duel.Damage(p,d,REASON_EFFECT)
	end
	if typ&TYPE_TRAP~=0 then
		local ex1,g1=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
		if g1 then
			local tc1=g1:GetFirst()
			if tc1:IsRelateToEffect(e) then
				if res~=0 then Duel.BreakEffect() end
				res=Duel.Destroy(tc1,REASON_EFFECT)
			end
		end
	end
	if typ&TYPE_MONSTER~=0 then
		local ex2,g2=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
		if g2 then
			local tc2=g2:GetFirst()
			if tc2:IsRelateToEffect(e) then
				if res~=0 then Duel.BreakEffect() end
				Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
