--ペンデュラム・ディメンション
---@param c Card
function c84274024.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(84274024,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c84274024.effcon)
	e2:SetTarget(c84274024.sptg)
	e2:SetOperation(c84274024.spop)
	e2:SetLabel(TYPE_FUSION)
	c:RegisterEffect(e2)
	--to hand
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(84274024,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetTarget(c84274024.thtg1)
	e3:SetOperation(c84274024.thop1)
	e3:SetLabel(TYPE_SYNCHRO)
	c:RegisterEffect(e3)
	--to hand
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(84274024,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetTarget(c84274024.thtg2)
	e4:SetOperation(c84274024.thop2)
	e4:SetLabel(TYPE_XYZ)
	c:RegisterEffect(e4)
	--
	if not c84274024.global_check then
		c84274024.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		ge1:SetCode(EFFECT_MATERIAL_CHECK)
		ge1:SetValue(c84274024.valcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function c84274024.valcheck(e,c)
	local g=c:GetMaterial()
	if c:IsType(TYPE_FUSION) and g:IsExists(Card.IsFusionType,1,nil,TYPE_PENDULUM)
		or c:IsType(TYPE_SYNCHRO) and g:IsExists(Card.IsSynchroType,1,nil,TYPE_PENDULUM)
		or c:IsType(TYPE_XYZ) and g:IsExists(Card.IsXyzType,1,nil,TYPE_PENDULUM) then
		c:RegisterFlagEffect(84274024,RESET_EVENT+0x4fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c84274024.effcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) and eg:GetCount()==1
		and ec:IsSummonPlayer(tp) and ec:IsFaceup() and ec:IsType(e:GetLabel()) and ec:GetFlagEffect(84274024)~=0
end
function c84274024.spfilter(c,e,tp,lv)
	local lvl=c:GetOriginalLevel()
	return lvl>0 and lvl==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c84274024.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c84274024.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,eg:GetFirst():GetOriginalLevel())
		and Duel.GetFlagEffect(tp,84274024)==0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c84274024.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,84274024)~=0 then return end
	local c=e:GetHandler()
	if eg:GetFirst():IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c84274024.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg:GetFirst():GetOriginalLevel())
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
		end
		Duel.SpecialSummonComplete()
	end
	Duel.RegisterFlagEffect(tp,84274024,RESET_PHASE+PHASE_END,0,1)
end
function c84274024.thfilter1(c)
	return c:IsCode(24094653) and c:IsAbleToHand()
end
function c84274024.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c84274024.thfilter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFlagEffect(tp,84274025)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c84274024.thop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,84274025)~=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c84274024.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.RegisterFlagEffect(tp,84274025,RESET_PHASE+PHASE_END,0,1)
end
function c84274024.thfilter2(c,e,tp,ft,rk)
	return c:IsLevelBelow(rk) and c:IsType(TYPE_TUNER) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c84274024.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c84274024.thfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,ft,eg:GetFirst():GetRank())
		and Duel.GetFlagEffect(tp,84274026)==0 end
end
function c84274024.thop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,84274026)~=0 or eg:GetFirst():IsFacedown() then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c84274024.thfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,ft,eg:GetFirst():GetRank())
	local tc=g:GetFirst()
	if tc then
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
	Duel.RegisterFlagEffect(tp,84274026,RESET_PHASE+PHASE_END,0,1)
end
