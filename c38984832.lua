--第５５次GMX試験報告
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion summon
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=s.pre_select_mat_location,
		fusion_spell_matfilter=s.fusion_spell_matfilter,
		additional_fcheck=s.fcheck,
		additional_fgoalcheck=s.gcheck
	})
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.digtg)
	e2:SetOperation(s.digop)
	c:RegisterEffect(e2)
end
function s.fusfilter(c)
	return c:IsRace(RACE_DINOSAUR)
end
function s.oppmonster(tp)
	return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
end
function s.pre_select_mat_location(_,tp)
	local loc=LOCATION_HAND|LOCATION_MZONE
	if s.oppmonster(tp) then
		loc=loc|LOCATION_DECK
	end
	return loc
end
function s.fusion_spell_matfilter(c)
	return not c:IsLocation(LOCATION_DECK) or c:IsSetCard(0x1dd)
end
function s.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function s.gcheck(tp,mg,fc,mg_all,e)
	return mg_all:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function s.thfilter(c)
	return c:IsSetCard(0x1dd) and c:IsAbleToHand()
end
function s.deckgmx(c)
	return c:IsSetCard(0x1dd)
end
function s.confirm_decktop_s(tp,count)
	local max_decktop=5
	if count>max_decktop then
		local g=Duel.GetDecktopGroup(tp,count)
		Duel.ConfirmCards(1-tp,g)
	else
		Duel.ConfirmDecktop(tp,count)
	end
end
function s.digtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_DECK)
end
function s.digop(e,tp,eg,ep,ev,re,r,rp)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dcount==0 then return end
	local mg=Duel.GetMatchingGroup(s.deckgmx,tp,LOCATION_DECK,0,nil)
	if mg:GetCount()==0 then return end
	local seq=-1
	local qc=nil
	for sc in aux.Next(mg) do
		if sc:GetSequence()>seq then
			seq=sc:GetSequence()
			qc=sc
		end
	end
	if not qc then return end
	local nflip=dcount-seq
	s.confirm_decktop_s(tp,nflip)
	if e:GetHandler():IsSetCard(0x1dd) then
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+1595137,e,0,tp,tp,0)
	end
	local g=Duel.GetDecktopGroup(tp,nflip)
	if g:GetCount()==0 then return end
	if qc:IsAbleToHand() then
		Duel.SendtoHand(qc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,Group.FromCards(qc))
		Duel.ShuffleHand(tp)
	else
		Duel.SendtoGrave(qc,REASON_RULE)
	end
	Duel.ShuffleDeck(tp)
end
