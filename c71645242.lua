--ブラック・ガーデン
---@param c Card
function c71645242.initial_effect(c)
	aux.AddCodeList(c,71645242)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(71645242,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_CUSTOM+71645242)
	e4:SetTarget(c71645242.sptg)
	e4:SetOperation(c71645242.spop)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(71645242,1))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTarget(c71645242.sptg2)
	e5:SetOperation(c71645242.spop2)
	c:RegisterEffect(e5)
	if not c71645242.global_check then
		c71645242.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetCondition(c71645242.regcon)
		ge1:SetOperation(c71645242.regop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
function c71645242.cfilter(c,tp)
	local code,code2=c:GetSpecialSummonInfo(SUMMON_INFO_CODE,SUMMON_INFO_CODE2)
	return c:IsFaceup() and c:IsControler(tp) and code~=71645242 and code2~=71645242
end
function c71645242.regcon(e,tp,eg,ep,ev,re,r,rp)
	local sf=0
	if eg:IsExists(c71645242.cfilter,1,nil,0) then
		sf=sf+1
	end
	if eg:IsExists(c71645242.cfilter,1,nil,1) then
		sf=sf+2
	end
	e:SetLabel(sf)
	return sf~=0
end
function c71645242.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+71645242,e,r,rp,ep,e:GetLabel())
end
function c71645242.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c71645242.opfilter(c,e)
	return c:IsLocation(LOCATION_MZONE) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e)
end
function c71645242.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c71645242.opfilter,nil,e)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	while tc do
		if tc:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(math.ceil(tc:GetAttack()/2))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
	Duel.BreakEffect()
	if bit.extract(ev,tp)~=0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,71645243,0,TYPES_TOKEN_MONSTER,800,800,2,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,1-tp) then
		local token=Duel.CreateToken(tp,71645243)
		Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
	end
	if bit.extract(ev,1-tp)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE,1-tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(1-tp,71645243,0,TYPES_TOKEN_MONSTER,800,800,2,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP_ATTACK) then
		local token=Duel.CreateToken(1-tp,71645243)
		Duel.SpecialSummonStep(token,0,1-tp,tp,false,false,POS_FACEUP_ATTACK)
	end
	Duel.SpecialSummonComplete()
end
function c71645242.desfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT)
end
function c71645242.filter2(c,atk,e,tp)
	return c:IsAttack(atk) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71645242.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c71645242.filter2(chkc,e:GetLabel(),e,tp) end
	local g=Duel.GetMatchingGroup(c71645242.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local atk=g:GetSum(Card.GetAttack)
	local sc=g:FilterCount(Card.IsControler,nil,tp)
	if chk==0 then return g:GetCount()>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>-sc
		and Duel.IsExistingTarget(c71645242.filter2,tp,LOCATION_GRAVE,0,1,nil,atk,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectTarget(tp,c71645242.filter2,tp,LOCATION_GRAVE,0,1,1,nil,atk,e,tp)
	e:SetLabel(atk)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,1,0,0)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c71645242.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetMatchingGroup(c71645242.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	dg:AddCard(c)
	if Duel.Destroy(dg,REASON_EFFECT)==dg:GetCount() then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
