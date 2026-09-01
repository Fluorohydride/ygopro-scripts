--Yomagna the Fire Phantom
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.sprcon)
	e1:SetTarget(s.sprtg)
	e1:SetOperation(s.sprop)
	c:RegisterEffect(e1)
	--race
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.racetg)
	e2:SetOperation(s.raceop)
	c:RegisterEffect(e2)
	--fusion
	local e3=FusionSpell.CreateSummonEffect(c,{
		pre_select_mat_location=LOCATION_MZONE,
		pre_select_mat_opponent_location=LOCATION_MZONE,
		gc=function(e) return e:GetHandler() end
	})
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+o)
	e3:SetCondition(s.fspcon)
	c:RegisterEffect(e3)
end
function s.sprfilter(c)
	return c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost()
end
function s.gcheck(g)
	return g:IsExists(Card.IsType,3,nil,TYPE_MONSTER)
		or g:IsExists(Card.IsType,3,nil,TYPE_SPELL)
		or g:IsExists(Card.IsType,3,nil,TYPE_TRAP)
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and g:CheckSubGroup(s.gcheck,3,3)
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,s.gcheck,true,3,3)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_SPSUMMON)
	g:DeleteGroup()
end
function s.racetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local race=Duel.AnnounceRace(tp,1,RACE_ALL&~e:GetHandler():GetRace())
	e:SetLabel(race)
end
function s.raceop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local race=e:GetLabel()
	if c:IsRelateToChain() and c:IsFaceup() and bit.band(c:GetRace(),race)==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(race)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function s.fspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()&(PHASE_DAMAGE+PHASE_DAMAGE_CAL)==0
end
