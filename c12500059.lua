--Dawn Angel Kambi
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--special summon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.counterfilter(c)
	return c:IsRace(RACE_FAIRY)
end
function s.cfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_FAIRY)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.rcheck(g,tp,lv,ec)
	return g:GetSum(Card.GetLevel)==lv and Duel.GetMZoneCount(tp,g+ec)>0
		and Duel.CheckReleaseGroupEx(tp,Auxiliary.IsInGroup,#g,REASON_COST,false,nil,g)
end
function s.cfilter2(c,tp)
	return c:IsRace(RACE_FAIRY) and c:IsReleasable() and c:IsLevelAbove(1) and (c:IsControler(tp) or c:IsFaceup())
end
function s.filter(c,e,tp,lvt)
	local lv=c:GetLevel()
	return lvt[lv] and lv>0 and c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not c:IsRace(RACE_FAIRY)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsReleasable() or not c:IsRace(RACE_FAIRY) then return false end
	local clv=c:GetLevel()
	local rg=Duel.GetReleaseGroup(tp):Filter(s.cfilter2,c,tp)
	local lvt={}
	for lv=clv,12 do
		if lv==clv and Duel.GetMZoneCount(tp,c)>0 or rg:CheckSubGroup(s.rcheck,1,99,tp,lv-clv,c) then
			lvt[lv]=true
		end
	end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil,e,tp,lvt)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return #g>0
	end
	local alvt={}
	for lv=1,12 do
		if lvt[lv] and g:IsExists(Card.IsLevel,1,nil,lv) then
			alvt[#alvt+1]=lv
		end
	end
	local tglv=Duel.AnnounceNumber(tp,table.unpack(alvt))
	if tglv>clv then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=rg:SelectSubGroup(tp,s.rcheck,false,1,99,tp,tglv-clv,c)+c
		aux.UseExtraReleaseCount(sg,tp)
		Duel.Release(sg,REASON_COST)
	else
		Duel.Release(c,REASON_COST)
	end
	e:SetLabel(tglv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spfilter(c,e,tp,lv)
	return c:IsLevel(lv) and c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
