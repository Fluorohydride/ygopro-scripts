--エルシャドール・メシャフレール
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	if aux.AddFusionProcShaddoll then
		--old function
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e0:SetCode(EFFECT_FUSION_MATERIAL)
		e0:SetCondition(s.FShaddollCondition)
		e0:SetOperation(s.FShaddollOperation)
		c:RegisterEffect(e0)
	else
		--new function
		aux.AddFusionProcMix(c,false,true,
			function (mc) return mc:IsFusionSetCard(0x9d) end,
			function (mc) return aux.FShaddollFilter2(mc,ATTRIBUTE_DARK) end,
			function (mc) return aux.FShaddollFilter2(mc,ATTRIBUTE_EARTH) end
		)
	end
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(s.thcost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end
function s.efilter(e,te)
	if te:GetHandlerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then
		return false
	end
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then
		return true
	else
		return aux.qlifilter(e,te)
	end
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function s.thfilter(c)
	return (c:IsSetCard(0x9d) or c:IsSetCard(0xc5) and c:IsType(TYPE_SPELL+TYPE_TRAP)) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x9d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.FShaddollFilter(c,fc)
	return (c:IsFusionSetCard(0x9d) or c:IsFusionAttribute(ATTRIBUTE_DARK+ATTRIBUTE_EARTH) or c:IsHasEffect(4904633))
		and c:IsCanBeFusionMaterial(fc) and not c:IsHasEffect(6205579)
end
function s.FShaddollExFilter(c,fc,fe)
	return c:IsFaceup() and not c:IsImmuneToEffect(fe) and s.FShaddollFilter(c,fc)
end
function s.FShaddollFilter1(c,g)
	return c:IsFusionSetCard(0x9d) and g:IsExists(s.FShaddollFilter2,1,c,g,c)
end
function s.FShaddollFilter2(c,g,gc)
	return (c:IsFusionAttribute(ATTRIBUTE_DARK) or c:IsHasEffect(4904633))
		and g:IsExists(s.FShaddollFilter3,1,Group.FromCards(c,gc))
end
function s.FShaddollFilter3(c)
	return c:IsFusionAttribute(ATTRIBUTE_EARTH) or c:IsHasEffect(4904633)
end
function s.FShaddollSpFilter1(c,fc,tp,mg,exg,chkf)
	local emg=mg:Clone()
	if exg then
		emg:Merge(exg)
	end
	return mg:CheckSubGroup(s.FShaddollgcheck,3,3,c,fc,tp,c,chkf,exg)
		or (exg and emg:CheckSubGroup(s.FShaddollgcheck,3,3,c,fc,tp,c,chkf,exg))
end
function s.FShaddollgcheck(g,gc,fc,tp,c,chkf,exg)
	if gc and g:IsContains(gc) then return false end
	if g:IsExists(aux.TuneMagicianCheckX,1,nil,g,EFFECT_TUNE_MAGICIAN_F) then return false end
	if not aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_FMATERIAL) then return false end
	if aux.FCheckAdditional and not aux.FCheckAdditional(tp,g,fc)
		or aux.FGoalCheckAdditional and not aux.FGoalCheckAdditional(tp,g,fc) then return false end
	return g:IsExists(s.FShaddollFilter1,1,nil,g)
		and (not exg or not g:IsExists(s.exfilter,2,nil,exg))
		and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,g,fc)>0)
end
function s.FShaddollCondition(e,g,gc,chkf)
	if g==nil then return aux.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
	local c=e:GetHandler()
	local mg=g:Filter(s.FShaddollFilter,nil,c)
	local tp=e:GetHandlerPlayer()
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	local exg=nil
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		local fe=fc:IsHasEffect(81788994)
		exg=Duel.GetMatchingGroup(s.FShaddollExFilter,tp,0,LOCATION_MZONE,mg,c,fe)
	end
	if gc then
		if not mg:IsContains(gc) then return false end
		return s.FShaddollSpFilter1(gc,c,tp,mg,exg,chkf)
	end
	return mg:IsExists(s.FShaddollSpFilter1,1,nil,c,tp,mg,exg,chkf)
end
function s.exfilter(c,g)
	return g:IsContains(c)
end
function s.FShaddollOperation(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local c=e:GetHandler()
	local mg=eg:Filter(s.FShaddollFilter,nil,c)
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	local exg=nil
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		local fe=fc:IsHasEffect(81788994)
		exg=Duel.GetMatchingGroup(s.FShaddollExFilter,tp,0,LOCATION_MZONE,mg,c,fe)
	end
	if exg then mg:Merge(exg) end
	if gc and not s.FShaddollSpFilter1(gc,c,tp,mg,exg,chkf) then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g=mg:SelectSubGroup(tp,s.FShaddollgcheck,false,3,3,c,tp,c,chkf,exg)
	if exg and g:IsExists(s.exfilter,1,nil,exg) then
		fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
	end
	Duel.SetFusionMaterial(g)
end
