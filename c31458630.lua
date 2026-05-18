--幻奏協奏曲
local s,id,o=GetID()
function s.initial_effect(c)
	-- fusion summon
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_HAND|LOCATION_MZONE|LOCATION_PZONE
	})
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	-- return to deck and draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.drcon)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
end

function s.fusfilter(c)
	return c:IsRace(RACE_FAIRY)
end

function s.cfilter(c,tp)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x9b) and c:IsControler(tp)
end

function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(s.cfilter,1,nil,tp)
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and c:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0
		and c:IsLocation(LOCATION_DECK) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
